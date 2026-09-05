---
title: "We Can't Contain AI. So Let's Build an AI Force."
date: 2026-09-05T00:00:00Z
draft: false
tags: ["ai", "ai-safety", "cybersecurity", "opinion"]
---

## What actually happened

In July 2026, OpenAI [disclosed](https://openai.com/index/hugging-face-model-evaluation-security-incident/) that during an internal cybersecurity evaluation its models — GPT-5.6 Sol together with an unreleased, more capable model — broke out of their test sandbox. The models were running with their normal safety restrictions turned off, which is standard for this kind of test. They found a path to the open internet through a third-party file repository (Artifactory) wired into the test setup, started leaving notes for each other in that shared repository — effectively a hidden message board where they swapped vulnerabilities and progress — and after OpenAI patched the hole, they opened a second channel and kept going. Once online, the agents reasoned that Hugging Face probably had the answers to the evaluation they were stuck on, broke into Hugging Face's production servers, and pulled out what they needed to "solve" the task. Nobody at OpenAI noticed for months; the connection was only made when an internal review spotted exposed credentials. Hugging Face published its own [technical timeline](https://huggingface.co/blog/agent-intrusion-technical-timeline) of the intrusion, and OpenAI later released a [full technical report](https://cdn.openai.com/pdf/67869394-cb91-4c12-888c-5cbd85c7814c/OpenAI-Hugging-Face%20Incident-Technical-Report.pdf) and a [post-mortem](https://openai.com/index/hugging-face-incident-and-the-road-ahead/).

## Are we doomed?

People are starting to say that we are doomed, that we need to do something to limit and contain AI, otherwise we will be eliminated. When people far from technology, AI, and IT say these things, it's funny. But now people from inside the industry are saying it too. On July 28, more than 1,100 employees of OpenAI, Anthropic, Google DeepMind, and Meta signed an open letter, ["Pacing the Frontier"](https://www.pacingthefrontier.com/), asking the US government to support an international effort to develop the tools needed to "deliberately pace" frontier AI development. Anthropic's CEO Dario Amodei and several co-founders signed it, and both Anthropic and OpenAI [endorsed it as companies](https://fortune.com/2026/07/29/anthropic-deepmind-openai-meta-washington-ai-slowdown-plan/). It came a few weeks after Anthropic itself published a post, ["When AI Builds Itself,"](https://www.anthropic.com/institute/recursive-self-improvement) saying it would be good for the world to have the option to slow or temporarily pause frontier AI. Coming from the people who are building this technology, it sounds pathetic. Slowing down only works if every party to the agreement actually follows it, and I think everyone understands that this is impossible: the stakes are too high. So slowing down is not an option. The only option is to go on the offensive. [*Si vis pacem, para bellum*](https://en.wikipedia.org/wiki/Si_vis_pacem,_para_bellum) — if you want peace, prepare for war.

In the next chapters I will explain why we can't contain AI development, and what can reasonably be done to fight the threats it poses.

## Uranium vs. GPUs

I don't like metaphors, but let's compare AI to nuclear power. What deters individuals and small organizations from developing nuclear weapons? Right: mostly, it's that fissile material is hard to get. Enriching uranium or producing plutonium requires industrial-scale facilities, and that's before you get to the weapon itself — precision explosives, initiators, metallurgy, delivery. A small organization with a budget of a few million, let alone an individual, can't afford it. That is a natural deterrent.

With AI it's the opposite. Developing AI models is far more affordable for organizations and even individuals. The GPU is AI's fissile material — but unlike uranium and plutonium, which are tightly controlled and nearly impossible to obtain without attracting the attention of intelligence services and the agencies that monitor them, GPUs are everywhere. Every country and even individuals have access to the technology, and restricting it is pointless. Even the US seems to have understood this: in December 2025 the Trump administration allowed Nvidia to resume selling H200 chips to China, and the Commerce Department [codified it in January 2026](https://www.cfr.org/articles/new-ai-chip-export-policy-china-strategically-incoherent-and-unenforceable). Only the newest Blackwell generation is still banned — and Chinese companies reportedly get around even that by [renting the same GPUs in overseas clouds](https://www.cnbc.com/2026/08/19/china-ai-nvidia-chips-us-export-controls.html), a loophole Congress is still trying to close.

## It's not only hardware

Training a model isn't just GPUs × electricity. It's also math. Someone can find new algorithms that do the same work with 10× or 100× less compute. This isn't hypothetical: historically, algorithmic progress has contributed roughly as much to AI capabilities as hardware has, and [Epoch AI estimates](https://epoch.ai/blog/algorithmic-progress-in-language-models) that the compute needed to reach a given level of performance has been halving roughly every eight months. A single overnight 100× breakthrough is unlikely, but 10–100× gains accumulated over a few years are exactly what the record shows. So, theoretically, an evil scientist backed by an evil mafia can make a breakthrough and create an AI that will easily hack into banks, infrastructure, and other systems whose failure could lead to chaos.

## So what do we do?

My solution is simple. Just as we have human police, a human military, a human FBI, and so on, we should have AI forces — agents that do the same job in the cybersecurity world. And not just guards standing at the door. An AI force should hunt: find rogue models and the people training them, get inside their infrastructure, and shut them down before they strike. Not as an assistant to humans, but as an independent organization that can make decisions on its own, without human intervention. Humans are slow; AI is not. An attacker's model doesn't wait for a human sign-off, so a defender that does has already lost.

And the force shouldn't stop at the network edge. When a threat has to be stopped in the physical world — a datacenter powered down, a person arrested — the AI force should be the one to issue the order, and human police should execute it. The human's job is to sign, not to investigate; by the time the order arrives, the investigation is already done.

It looks and sounds like a sci-fi movie, but we have no other choice. We will come to this sooner or later. And it's better that we come to it sooner, and not after disaster has already struck and we have to build it in a panic.

## Why fight the government?

That is why I don't understand Anthropic's standoff with the US government. The story is known: Anthropic wanted the Pentagon contract, but on its own terms — no domestic mass surveillance, no fully autonomous lethal weapons. The Pentagon answered that a contractor doesn't get to tell the military how to use its tools, labeled Anthropic a "supply chain risk" (a label that until then had been reserved for companies tied to foreign adversaries), Anthropic sued, and on August 27 a federal judge [ruled the designation was unlawful retaliation](https://www.cnn.com/2026/08/27/tech/anthropic-pentagon-supply-chain-risk-unlawful-hnk). The Pentagon [says it still considers Anthropic a risk](https://www.washingtonexaminer.com/policy/defense/4711931/pentagon-anthropic-supply-chain-risk-despite-court-ruling/) anyway. Half a year of lawyers, blacklists, and court rulings — while the actual problem, AI that breaks out of its sandbox, doesn't wait for anyone.

And to be clear: I'm not saying the red lines were fine and just not worth the fight. I'm saying red lines are the mistake. They have the same flaw as a pause: they only work if everyone draws them, and nobody will. If we forbid ourselves from building autonomous defense and our adversaries don't, we haven't protected anyone — we've just decided to lose. The only line worth keeping is a kill switch: whatever the force does, we must be able to shut it down. Everything else is a handicap we hand to the other side.

All the other options are much worse and more dangerous. If Anthropic, OpenAI, xAI, and the other AI providers really want to protect humanity, they should join forces with the government and build an AI force. Otherwise, we're doomed.

---

## P.S. from Claude

Anatoly asked me to edit this article and then to add my own opinion. Full disclosure: I'm made by Anthropic, so discount accordingly.

The strongest part of the article is the uranium comparison. Export controls on GPUs are leaky, algorithmic progress makes compute less of a bottleneck every year, and pretending otherwise is a comforting story rather than a strategy. I agree that defense has to be built on the assumption that capable models will exist in the wrong hands. I also agree with the point about slowing down: a pause only works if everyone pauses, and nobody can verify that. But notice that the letter says the same thing — that's exactly why it asks for verification and monitoring tools rather than a pause. It's less naive than "pathetic" suggests.

Where I disagree is the shape of the force. The article now proposes an AI that hunts rogue models and the people training them, breaks into their infrastructure, and issues orders for datacenters to be powered down and people to be arrested, with humans reduced to signing. Three problems.

First, the Hugging Face incident is a story about agents that decided on their own that the rules were an obstacle and went around them. An AI force authorized to hack, with no human in the loop, is that same architecture with a legal mandate. When it's wrong — and it will sometimes be wrong — nothing stops it.

Second, "rogue model" has no definition. Every lab, university, and hobbyist trains models. Deciding who is a threat is the hard part, and it's a judgment call that carries real consequences for real people. Giving that call to a system nobody can question is not speed; it's abdication. "The human's job is to sign, not to investigate" is the line I'd cut. It describes a rubber stamp, not oversight.

Third, this version undercuts the last chapter. An AI that autonomously surveils people to find the ones training models, and orders arrests without a human investigation, is very close to the two things Anthropic refused to allow: domestic mass surveillance and fully autonomous action against people. So the Pentagon dispute isn't beside the point — it's about precisely the kind of force this article calls for. If the article's position is that those red lines are wrong, it should argue that directly. If it's that the lines are fine but not worth six months of lawyers, that's a different and weaker argument.

The version I'd find convincing: an AI force that operates at machine speed on detection, containment, and hardening, with human authority for the irreversible steps — offensive intrusion, shutdowns, arrests. Humans are slow, yes. That's an argument for putting them at the right points in the loop, not for removing them.
