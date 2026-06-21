# Launch Post Drafts

## Primary

I built a small workflow I wish every "subagent swarm" had: brakes.

Before the agent runs full blast, it checks the spend limit.

If budget is safe, it can fan out.
If spend is high, it uses fewer read-only scouts.
If spend is blocked, it stays direct or uses one compact reviewer.

The useful part is not just cost control. It also stops duplicate discovery,
caps noisy output, requires receipts, and forces the agent to separate local,
committed, pushed, and live work.

I called it Bounded Agents because the goal is not less agent power. The goal is
controlled agent power: budget, scope, proof, and stop rules.

Repo: [link]

## Shorter

I made a budget-aware version of "full blast" subagents.

The agent checks spend before fanout, reduces lanes when cost is high, blocks
duplicate discovery, and ends with receipts instead of vibes.

Controlled delegation beats unbounded agent sprawl.

Repo: [link]

## Thread Option

1/ I have been using "full blast" subagents for bigger AI/code tasks. Powerful,
but easy to waste tokens if every lane rereads the same context.

So I added a cost gate.

2/ Before fanout, the controller checks spend/quota state and labels the run:
safe, caution, blocked, or unavailable.

That label changes how many agents run.

3/ Safe: normal bounded fanout.
Caution: 2-3 read-only scouts first.
Blocked: direct work or one compact scout only.

4/ The workflow also requires a controller evidence packet, no duplicate
discovery, bounded outputs, lane receipts, and clean local/commit/push/live
status.

5/ The point is not to make agents timid. It is to make them accountable.

Subagents should expand judgment, not just multiply context and spend.

Repo: [link]
