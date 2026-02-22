---
title: "MetalLB LoadBalancer IPs Unreachable from macOS Host (QEMU/Talos)"
date: 2026-02-22T00:00:00Z
draft: false
tags: ["kubernetes", "metallb", "macos", "qemu", "talos", "networking", "troubleshooting"]
---

I run a local Kubernetes cluster on macOS using [Talos Linux](https://www.talos.dev/) with QEMU. The cluster uses [MetalLB](https://metallb.universe.tf/) in L2 mode to assign external IPs to LoadBalancer services — the same way it works in production on bare metal. Everything inside the cluster was fine. But from my Mac, I couldn't reach the LoadBalancer IP at all.

```
$ curl -k --connect-timeout 3 https://10.5.0.10
curl: (28) Failed to connect to 10.5.0.10 port 443 after 3005 ms: Timeout was reached
```

This took me a while to figure out, so here's the full story.

## The Setup

- macOS on Apple Silicon
- 3 Talos Linux control-plane nodes running as QEMU VMs
- Nodes at `10.5.0.2`, `.3`, `.4` — all reachable from the Mac
- MetalLB L2 pool: `10.5.0.10-10.5.0.20`
- Traefik as the ingress controller, getting `10.5.0.10` as its LoadBalancer IP

The node IPs worked fine. I could `ping 10.5.0.2` no problem. But `10.5.0.10`? Completely dead. No ping, no curl, nothing.

## Quick Networking Primer

If you're mostly a software developer (like me), here's what's relevant:

**ARP (Address Resolution Protocol)** — when your Mac wants to send a packet to `10.5.0.10`, it first needs to know the physical hardware address (MAC address) of the machine that owns that IP. It broadcasts an ARP request: "who has 10.5.0.10?" The owner responds: "that's me, here's my MAC address." Your Mac then sends the actual packet to that MAC address.

**MetalLB L2 mode** works by having a pod on one of your nodes respond to ARP requests for the LoadBalancer IP. When someone asks "who has 10.5.0.10?", MetalLB's speaker pod says "me!" and provides the MAC address of the node it's running on. Traffic then flows to that node, where kube-proxy forwards it to the right pod.

**vmnet-shared** is the virtual networking mode that QEMU uses on macOS. It creates a NAT network with a built-in DHCP server. The VMs get their IPs (`.2`, `.3`, `.4`) from this DHCP server.

## Root Cause: vmnet-shared Drops Gratuitous ARP

Here's the problem. When `talosctl` creates QEMU VMs on macOS, it launches them with:

```
-netdev vmnet-shared,id=net0,start-address=10.5.0.1,end-address=10.5.0.5,subnet-mask=255.255.255.0
```

Apple's `vmnet.framework` in shared mode only forwards traffic for IPs that its own DHCP server assigned. It maintains an internal table of leased IPs and silently drops everything else.

MetalLB's speaker pod sends a "gratuitous ARP" from inside a VM announcing that `10.5.0.10` belongs to it. But vmnet-shared never forwarded that announcement to the Mac. The ARP reply never arrives. From the Mac's perspective, the IP simply doesn't exist:

```
$ arp -n 10.5.0.10
? (10.5.0.10) at (incomplete) on bridge102 ifscope [bridge]
```

`(incomplete)` means the Mac sent an ARP request and got no response.

I even tried adding a static ARP entry — didn't help either. vmnet-shared filters at the IP level, not just ARP. If its DHCP server didn't assign the IP, traffic doesn't flow. Period.

## What About Moving the VIP Into the DHCP Range?

My first thought was: the DHCP range is `10.5.0.1–10.5.0.5`, and MetalLB VIP is at `.10`. What if I move the VIP pool into the DHCP range?

I changed the MetalLB pool to `10.5.0.5/32` (the only free IP in the DHCP window) and tested:

```
$ curl -k --connect-timeout 3 https://10.5.0.5
curl: (7) Failed to connect to 10.5.0.5 port 443: Couldn't connect to server
```

Nope. vmnet-shared only forwards traffic to IPs that it actually **leased** via DHCP. Being in the range isn't enough — the IP must be actively assigned to a VM. Since no VM requested `10.5.0.5` via DHCP, vmnet drops it too.

## The Fix: Static Route Through a Node IP

The solution comes from the [Run multiple Kubernetes clusters on MacOS with LoadBalancer support](https://baptistout.net/posts/kubernetes-clusters-on-macos-with-loadbalancer-without-docker-desktop/) article and a [Lima + MetalLB discussion](https://github.com/lima-vm/lima/discussions/408).

The idea: instead of relying on ARP, add a static route on macOS that sends VIP traffic to a node IP. The node IPs (`.2`, `.3`, `.4`) are DHCP-assigned, so vmnet happily forwards traffic to them. Once the packet reaches a node, kube-proxy sees the destination is a LoadBalancer VIP and DNATs (forwards) it to the right pod.

```bash
sudo route -nv add -net 10.5.0.8/29 10.5.0.2
```

This tells macOS: "to reach `10.5.0.8/29` (which includes `.10`), send packets to node `.2`."

```
$ curl -k --connect-timeout 3 https://10.5.0.10
404 page not found
```

A 404 from Traefik! That's a success — the packet made it all the way through. Traefik responded with 404 because I was hitting a bare IP instead of a hostname. With a proper hostname:

```
$ curl -k --connect-timeout 3 https://argocd.dev.ankimcp.ai
```

Everything works.

## The Pitfall: Don't Use /28

My first attempt was a `/28` route:

```bash
# DON'T DO THIS
sudo route -nv add -net 10.5.0.10/28 10.5.0.2
```

This broke `kubectl` immediately:

```
$ kubectl get nodes
Unable to connect to the server: dial tcp 10.5.0.1:6443: connect: network is unreachable
```

Why? A `/28` subnet covers 16 addresses. macOS masks `10.5.0.10/28` to the network boundary `10.5.0.0/28`, which covers `.0` through `.15`. That includes `.1` — the API server address in my kubeconfig. The route hijacked API server traffic, routing it through node `.2` instead of directly to the vmnet gateway. The node couldn't forward it back properly, and kubectl died.

**The safe choice: `/29`**. A `/29` from `.8` covers `.8–.15`, which includes MetalLB VIPs `.10–.15` while avoiding `.0–.7` (gateway and nodes). Six VIPs is more than enough for local development.

```bash
# This is correct
sudo route -nv add -net 10.5.0.8/29 10.5.0.2
```

## Making It Permanent (Per Cluster Lifecycle)

The route doesn't survive a macOS reboot. But if you're using ephemeral QEMU clusters (like Talos), the cluster doesn't survive either. So I added the route to the cluster create/destroy scripts:

```bash
# In your create script (runs as root):
route -nv add -net 10.5.0.8/29 10.5.0.2

# In your destroy script:
route -nv delete -net 10.5.0.8/29 10.5.0.2 2>/dev/null || true
```

## The Proper Fix: socket_vmnet

The static route is a workaround. The real fix is [socket_vmnet](https://github.com/lima-vm/socket_vmnet) — a project by the [Lima](https://github.com/lima-vm/lima) team that creates a proper L2 bridge between the Mac and VMs. With socket_vmnet, your Mac sits on the same network segment as the VMs, and MetalLB's ARP announcements work natively. No routes needed.

Quick clarification on the tools, since these names confused me at first:

- **QEMU** — the hypervisor that actually runs VMs
- **Lima** — a macOS tool that wraps QEMU, adds file sharing, port forwarding, and networking management (including socket_vmnet). Think "easy Linux VMs on Mac"
- **Colima** — wraps Lima specifically for running Docker/containerd on macOS. It's "Docker Desktop without Docker Desktop"
- **talosctl** — runs Talos Kubernetes VMs using QEMU directly, without Lima

Since `talosctl` talks to QEMU directly, it uses Apple's raw `vmnet-shared` networking and inherits all its limitations. As of February 2026, there's no flag to switch to socket_vmnet or vmnet-bridged. I opened a [feature request](https://github.com/siderolabs/talos/issues/12834) for it.

### Testing socket_vmnet

I verified this actually works by simulating what MetalLB does — claiming a VIP via gratuitous ARP from inside a QEMU VM.

**Setup** (one-time):
```bash
brew install socket_vmnet
sudo brew services start socket_vmnet
curl -L -o /tmp/alpine.iso https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/aarch64/alpine-virt-3.21.3-aarch64.iso
```

**Boot a VM through socket_vmnet** (instead of vmnet-shared):
```bash
/opt/homebrew/opt/socket_vmnet/bin/socket_vmnet_client \
  /opt/homebrew/var/run/socket_vmnet \
  qemu-system-aarch64 \
    -machine virt,accel=hvf \
    -cpu max -m 512 -nographic \
    -drive if=pflash,format=raw,readonly=on,file=/opt/homebrew/share/qemu/edk2-aarch64-code.fd \
    -cdrom /tmp/alpine.iso \
    -netdev socket,id=net0,fd=3 \
    -device virtio-net-pci,netdev=net0
```

**Inside the VM** (login as `root`, no password):
```bash
ip link set eth0 up
udhcpc -i eth0                              # get a real IP from socket_vmnet DHCP
ip addr add 192.168.105.50/32 dev eth0      # claim a VIP (simulating MetalLB)
arping -U -c 5 -I eth0 192.168.105.50      # send gratuitous ARP (like MetalLB speaker)
```

**From the Mac host:**
```
$ ping -c 3 192.168.105.50
64 bytes from 192.168.105.50: icmp_seq=0 ttl=64 time=0.520 ms
64 bytes from 192.168.105.50: icmp_seq=1 ttl=64 time=0.660 ms
64 bytes from 192.168.105.50: icmp_seq=2 ttl=64 time=0.848 ms
--- 3 packets transmitted, 3 packets received, 0.0% packet loss

$ arp -n 192.168.105.50
? (192.168.105.50) at 52:54:0:12:34:56 on bridge102 ifscope [bridge]
```

Compare that with vmnet-shared, where the same test gives `(incomplete)` ARP and 100% packet loss. The gratuitous ARP from the VM reaches the Mac through socket_vmnet's L2 bridge, exactly the way it would on a physical network. MetalLB L2 would work natively.

To quit the VM: `Ctrl+A` then `X`.

## Summary

| What | Works? |
|------|--------|
| Node IPs from Mac (vmnet-shared) | Yes — DHCP-assigned |
| MetalLB VIPs from Mac (vmnet-shared) | No — gratuitous ARP dropped |
| Static ARP entry for VIP | No — vmnet filters by IP, not just ARP |
| VIP moved into DHCP range | No — must be actually DHCP-leased |
| Static route `/28` through node | Breaks kubectl (catches API server `.1`) |
| Static route `/29` through node | Yes |
| socket_vmnet (bridged L2) | Yes, but requires changing QEMU launch |

The one-liner fix:

```bash
sudo route -nv add -net 10.5.0.8/29 10.5.0.2
```

Replace `10.5.0.8/29` with whatever `/29` covers your MetalLB pool, and `10.5.0.2` with any of your node IPs. Make sure the route doesn't cover your API server address.
