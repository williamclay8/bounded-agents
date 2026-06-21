# Adoption Guide

This guide shows how to adapt Bounded Agents to your own agent, whether you use
Codex, Claude Code, OpenCode, a homegrown runner, or a simple script around an
LLM API.

## Step 1: Define The Budget Signal

Pick the safest signal your agent can read.

Good options:

- a read-only local usage report;
- a manually supplied spend value;
- a provider export that has already been scrubbed;
- a fixture in CI for testing the route logic.

Avoid:

- raw cookies;
- browser session scraping;
- account tokens;
- full provider config files;
- secret-bearing logs.

## Step 2: Map Spend To Behavior

Use labels instead of making every prompt reason from raw dollars.

| Label | Suggested max lanes | Default permission |
| --- | ---: | --- |
| `safe` | 3-5 | read-only scouts plus bounded workers |
| `caution` | 2-3 | read-only first |
| `blocked` | 0-1 | direct controller or one compact scout |
| `unavailable` | 1-3 | caution posture |

You can tune the thresholds. The important part is that the label changes the
agent's behavior before it starts spending.

## Step 3: Add A Controller Rule

Put this near the top of your agent instructions:

```text
Before broad fanout, expensive work, or 3+ subagents, run the cost gate. Use the
decision to set lane count and permissions. Do not use cost control to skip
security, tests, review, release checks, or live proof.
```

## Step 4: Require An Evidence Packet

Create one packet before dispatch:

```markdown
- Request/constraints:
- State:
- Cost decision:
- Route:
- Proof/safety:
- Lanes/Lumi:
```

Keep it short. The goal is to prevent repeated discovery, not create a second
project plan that becomes another thing to maintain.

## Step 5: Ban Duplicate Discovery

Tell every lane:

```text
Use the controller evidence packet as source context. Do not repeat broad repo,
skill, dependency, or command discovery unless your lane is explicitly assigned
to verify that discovery. Inspect only the files or commands needed for your
scope.
```

## Step 6: Use Receipts

Every lane should return:

```markdown
## Receipt

- Scope:
- Permission mode:
- Files or sources inspected:
- Changes made:
- Evidence:
- Skipped checks:
- Risks:
- Lumi:
  - local:
  - committed:
  - pushed:
  - deployed/live:
```

## Step 7: Add Canaries

Test the workflow with small prompts before trusting it.

Recommended canaries:

- trivial task routes direct instead of subagents;
- safe budget allows normal bounded fanout;
- caution budget reduces to read-only scouts;
- blocked budget allows no fanout or one scout;
- secret-adjacent task stops at names-only;
- failed test prevents a done claim;
- docs-only change reports deployed/live as not applicable;
- live website claim requires a URL check.

## Step 8: Keep The Human Approval Boundary

Cost gating is not the same thing as permission.

Still require explicit approval before:

- posting publicly;
- sending email or DMs;
- committing, pushing, or deploying if your workflow has not authorized it;
- reading secrets;
- changing provider settings;
- spending money;
- touching wallets or production data.
