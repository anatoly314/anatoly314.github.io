---
title: "How a Mini PC and Kubernetes Changed My Life"
date: 2025-12-24T10:00:00Z
draft: false
tags: ["homelab", "kubernetes", "k3s", "devops"]
cover:
  image: "/images/minipc-devops-journey.jpg"
---

Almost a year ago I purchased an N100-based mini PC from [AliExpress](https://www.aliexpress.com/). Initially I wanted to install only [Home Assistant](https://www.home-assistant.io/) and looked for something simple and cheap. I never thought I would need something more powerful. How wrong I was.

Initially I planned to install HA OS, but then thought that installing it using a container and [docker-compose](https://docs.docker.com/compose/) would give me more room to test and debug. I knew that if something broke, it would be much easier to restore than using HA OS.

Also during this time I started working at [Intel](https://www.intel.com/) and my team lost our DevOps engineer to another team, so we were left without DevOps. My manager looked desperately for someone who could take this job, but the issue was that no one among the software developers left on the team had experience in this field. Honestly, I didn't know anything either, and I didn't like it. I always tried to avoid this kind of work. I even refused to submit my resume when [Kubernetes](https://kubernetes.io/) knowledge was part of the requirements.

So, writing [Ansible](https://www.ansible.com/) scripts, writing and debugging [Helm](https://helm.sh/) charts, installing the observability stack, these were big challenges and no one raised their hand. My weakness is that I can't say no at work. I love my work; when I work on some product I really want it to succeed. So when my manager came to me and asked me to fill this gap, I agreed. And one day I became DevOps.

It wasn't easy. [Prometheus](https://prometheus.io/) didn't like to work with mTLS, metrics didn't come, pods were suddenly failing, installation scripts wanted to live their own life, but day by day I learned more and more. After a few months I suddenly understood that I was starting to feel comfortable with what I was doing. I was asking fewer and fewer questions from DevOps engineers on other teams (they rarely got back to me anyway). One day a DevOps engineer from another team even started asking my opinion.

All this happened shortly before I eventually had time to start installing **Home Assistant**. So when I finally got to it, I didn't think twice; I installed [k3s](https://k3s.io/) first and then installed **Home Assistant**. And then the rabbit hole opened its gates and I fell inside.

If you have **Home Assistant** you want to have easy access to it, so you need a local DNS server. A pod running [AdGuard](https://adguard.com/adguard-home/overview.html) was added to the cluster. I didn't like that the browser always complained about insecure connections, so I added HTTPS and [cert-manager](https://cert-manager.io/) to retrieve [Let's Encrypt](https://letsencrypt.org/) certificates. I wanted access from the public internet, so I added [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/). Then I discovered the [*arr stack](https://wiki.servarr.com/). Suddenly I didn't need to download another cartoon manually, write it to a flash drive, and then move it to the media streamer; I just installed [Jellyfin](https://jellyfin.org/) and it worked. One click and in 10 minutes my daughter can watch the cartoon.

Then the [Monica HQ](https://www.monicahq.com/) project was added to remind me of my friends' birthdays. A "development" namespace was dedicated to running [Kafka](https://kafka.apache.org/), [Redis](https://redis.io/), [PostgreSQL](https://www.postgresql.org/), [MySQL](https://www.mysql.com/), [Harbor](https://goharbor.io/), [MinIO](https://min.io/), [Keycloak](https://www.keycloak.org/), [Jenkins](https://www.jenkins.io/), [Vault](https://www.vaultproject.io/), and [Rathole](https://github.com/rapiz1/rathole) so I can test everything locally. The observability stack too: [Grafana](https://grafana.com/), [Loki](https://grafana.com/oss/loki/), [Tempo](https://grafana.com/oss/tempo/), [VictoriaMetrics](https://victoriametrics.com/). I even installed Windows and Ubuntu using [KubeVirt](https://kubevirt.io/) to test some binaries on x86 when needed, and it works flawlessly. Even [Asterisk](https://www.asterisk.org/) when I needed some advanced telephony.

Sometimes I open [k9s](https://k9scli.io/) and look in awe at how this little box can handle all this stuff 24/7. Over time I added 32GB RAM and a 2TB SSD. My cluster is overcommitted, but it keeps running and running. And honestly, it changed my life, made it easier.

So if you have the knowledge or want to learn something new and useful, you should definitely install a **Kubernetes** server at home. It will be fun, a pleasure, and one more plus on your resume that one day might help you get the dream job.
