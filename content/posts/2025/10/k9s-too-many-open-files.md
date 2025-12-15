---
title: "Fixing k9s 'Too Many Open Files' Error on K3s"
date: 2025-10-17T01:00:00Z
draft: false
tags: ["kubernetes", "k3s", "k9s", "troubleshooting", "homelab"]
---

## The Problem

I was using k9s to check logs on my K3s homelab cluster when I hit this frustrating error:

```
to create fsnotify watcher: too many open files
stream closed: EOF for development/drawdb-ddf8d9569-grfff (drawdb)
```

The log stream would just close immediately, and I couldn't see anything. Annoying.

## What's Actually Happening

Here's the thing - this isn't a problem with k9s on your laptop. It's happening on the K3s node itself. When applications watch files (like development tools, file syncing services, or even k9s monitoring your cluster), Linux uses something called inotify watchers. There's a limit to how many of these you can have.

On my server, I checked the limits:

```bash
sysctl fs.inotify.max_user_instances fs.inotify.max_user_watches
```

And got:
```
fs.inotify.max_user_instances = 128
fs.inotify.max_user_watches = 248097
```

That `max_user_instances` of 128? Way too low for a cluster running multiple apps that watch files.

## The Fix

SSH into your K3s node and create a file `/etc/sysctl.d/99-k3s.conf` with the following content:

```
fs.inotify.max_user_instances=512
fs.inotify.max_user_watches=524288
```

Then apply the changes:

```bash
# Apply the changes right away
sudo sysctl -p /etc/sysctl.d/99-k3s.conf

# Verify it worked
sysctl fs.inotify.max_user_instances fs.inotify.max_user_watches
```

You should see:
```
fs.inotify.max_user_instances = 512
fs.inotify.max_user_watches = 524288
```

That's it. No need to restart K3s or any pods. Just restart k9s and you're good to go.

## Why This Works

We're increasing two limits:
- `max_user_instances`: How many inotify instances a user can create (bumped from 128 to 512)
- `max_user_watches`: How many files each instance can watch (bumped to 524288)

The fix is permanent because we're creating a config file in `/etc/sysctl.d/` that survives reboots.

This is a pretty common issue on K3s clusters, especially if you're running development tools or anything that monitors file changes. If you run into this, just bump those limits and you'll be fine.
