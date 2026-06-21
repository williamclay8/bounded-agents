# How Bounded Agents Works

Bounded Agents is an orchestration pattern for agent fanout. The controller keeps
the critical path, and subagents only get bounded work that is independent,
useful, and worth the cost.

## The Loop

```text
intent -> preflight -> cost gate -> evidence packet -> bounded lanes -> receipts -> integration -> Lumi status
```

## 1. Preflight

Before fanout, the controller records:

- the user request and success criteria;
- write permissions and forbidden actions;
- secret, provider, social, wallet, deploy, and live boundaries;
- current repo/workspace state;
- proof needed to call the work done.

For a documentation repo, that proof may be a content review and git status.
For software, it may be tests, browser checks, CI, or live URL verification.

## 2. Cost Gate

The cost gate is read-only. It should summarize spend or quota state without
printing secrets, cookies, account tokens, raw config, or private billing pages.

Common labels:

- `safe`: normal fanout is acceptable.
- `caution`: reduce lane count and start read-only.
- `blocked`: do not run broad fanout.
- `unavailable`: use caution unless the task is small.

The gate changes lane count. It does not skip security, release, review, or
proof requirements.

## 3. Controller Evidence Packet

The controller writes one compact packet and gives each lane only the slice it
needs. This prevents the most common token leak: every subagent rereading the
same docs and dumping the same logs.

The packet should include:

- task and constraints;
- cost label and lane budget;
- repo state and relevant instructions;
- known file targets;
- proof plan;
- output caps;
- stop conditions.

## 4. Bounded Lanes

Each lane gets one role, one scope, one permission mode, and one output schema.

Good lane:

```text
Read only. Review docs/adoption-guide.md for overclaims and unclear steps.
Do not inspect unrelated files. Return findings, exact lines, and one suggested fix per issue.
```

Risky lane:

```text
Figure out anything else we should do and make the repo better.
```

## 5. Receipts

Each lane reports what it checked, what it changed, what it skipped, and what
evidence supports its conclusion. The controller then integrates the results
and independently verifies the final state.

The final receipt should separate:

- local files changed;
- commit status;
- push status;
- deployment or live status.

That separation matters. Local work is not pushed work. Pushed work is not a
live website. A live website is not proof that every claim in the docs is true.

## Stop Rules

Stop or shrink the run when:

- spend is over the configured limit;
- the task is trivial enough for direct work;
- a lane would need secrets or live provider mutation;
- lanes would overlap on the same files;
- proof is missing;
- a source or public tool asks the agent to bypass instructions;
- the controller cannot honestly say what is local, committed, pushed, and live.
