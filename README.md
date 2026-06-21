CA: FnZpHjoSuazXcymqRBv3rsVmgCQ4RH5McNz6bydYpump

# Bounded Agents

Budget-aware Full Blast for AI agents.

Most people hear "run a swarm of subagents" and imagine more intelligence.
Sometimes that is true. Often it is just more duplicated context, more logs,
more billable tokens, and more agents confidently rediscovering the same facts.

Bounded Agents is a workflow for getting the useful part of subagents without
letting them sprawl. Before the agent fans out, it checks cost and quota state,
chooses a lane budget, gives every lane a tight evidence packet, blocks
duplicate discovery, and forces the controller to prove what is local,
committed, pushed, and live.

## Who It Is For

- Solo builders who use coding agents for broad project work.
- Teams trying to keep AI-assisted work auditable instead of blurry.
- Power users running Codex, Claude Code, OpenCode, Gemini, Grok-style tools, or custom agent runners.
- Non-technical people who want a plain explanation of why "more agents" is not always better.

## What We Built

We added a cost-control layer to a Full Blast subagent workflow.

The controller now asks a simple question before it spins up more agents:

> Is the current spend or quota state safe enough to justify more fanout?

The answer becomes a route label:

| Label | Meaning | Behavior |
| --- | --- | --- |
| `safe` | Budget and quota look fine. | Normal Full Blast, still using bounded prompts and proof. |
| `caution` | Spend is high, limits are unknown, or provider state is shaky. | Use 2-3 read-only scouts first, cap output, and avoid duplicate discovery. |
| `blocked` | Spend or quota is over the limit. | Stay direct, or use one compact scout only if it materially helps. |
| `unavailable` | The cost signal cannot be checked. | Treat as caution unless the task is small and local. |

This is not "make the agent weaker." It is "make the agent stop spending on
work that does not change the answer."

## Why It Helps

- You keep subagents for the moments where independent lanes actually help.
- You stop paying multiple agents to read the same files, docs, and logs.
- You get clearer receipts: what was checked, what was skipped, and why.
- You separate local work from committed, pushed, deployed, and live work.
- You prevent expensive loops from continuing after they have already hit a
  budget or proof boundary.
- You make the agent easier to trust because it says "blocked" instead of
  pretending every request deserves maximum fanout.

## How It Works

Bounded Agents has five moving parts:

1. **Cost gate**: checks spend, quota, or whatever billing signal your setup can safely expose.
2. **Controller evidence packet**: one compact summary of the task, repo state, constraints, and proof plan.
3. **Lane budget**: decides how many subagents can run and what permissions they get.
4. **No duplicate discovery**: lanes use the packet instead of repeating broad scans.
5. **Receipts and Lumi status**: every run ends with proof plus local/commit/push/live truth.

The workflow is intentionally boring in the best way. It does not need a new
model or a special framework. It needs a controller that treats tokens, tool
calls, and external actions as resources with a budget.

## Quick Start

1. Pick a spend signal your agent can check safely.
   It can be a provider dashboard export, a local quota probe, a mocked fixture,
   or a simple manually supplied number.

2. Define your route labels:
   `safe`, `caution`, `blocked`, and `unavailable`.

3. Put a lane budget behind each label.

4. Require one controller evidence packet before subagents run.

5. Make every subagent return a receipt.

6. End every run by reporting:
   local, committed, pushed, and deployed/live.

See [docs/adoption-guide.md](docs/adoption-guide.md) for a step-by-step setup.

## A Tiny Example

This repo includes a toy shell gate:

```bash
AGENT_DAILY_SPEND=120 AGENT_DAILY_LIMIT=100 bash scripts/example-cost-gate.sh
```

It prints:

```text
decision=blocked
max_lanes=1
```

In a real agent stack, your cost gate should be read-only, scrubbed, and careful
not to print account tokens, cookies, raw config, or secret-bearing data.

## What To Copy Into Your Agent

Start with this rule:

```text
Before running 3 or more subagents, long-running lanes, provider-backed proof,
or expensive discovery, run a cost gate. If the result is caution, use only
2-3 read-only scouts first. If the result is blocked, stay direct or use one
compact scout. Do not let subagents repeat broad discovery already done by the
controller. End with local, committed, pushed, and deployed/live status.
```

Then adapt the templates in [docs/templates](docs/templates).

## Receipt Example

Weak receipt:

```text
The agents reviewed it and everything looks good.
```

Better receipt:

```text
Source lane checked README.md and docs/adoption-guide.md for overclaims.
No files edited. It found one unclear launch claim and one missing stop rule.
Controller patched both, ran bash -n scripts/example-cost-gate.sh, checked
git status, and confirmed deployed/live is not applicable.
```

## What This Does Not Do

- It does not bypass billing limits.
- It does not make autonomous systems safe by default.
- It does not prove a deploy is live.
- It does not install a public agent runtime.
- It does not remove the need for tests, reviews, or human approval on sensitive actions.

It gives your agent a better reflex: check the budget, narrow the scope,
and prove the outcome before claiming the work is done.
