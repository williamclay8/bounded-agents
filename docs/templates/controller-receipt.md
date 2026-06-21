# Controller Receipt Template

```markdown
- Request/constraints:
- State:
- Cost decision:
- Route:
- Proof/safety:
- Lanes/Lumi:
```

## Example

```markdown
- Request/constraints: Create public docs explaining budget-aware subagent fanout. Writes allowed in this repo only. No secrets, posting, deploys, or provider mutations.
- State: New docs repo, clean working tree at start, AGENTS.md loaded.
- Cost decision: blocked, so no broad fanout. One compact scout only.
- Route: Full Blast controller with reduced lane budget because the task is broad but cost constrained.
- Proof/safety: Markdown review, script syntax check, git status. Public claims stay source-bound.
- Lanes/Lumi: source/content scout read-only; local=dirty while editing, committed=no, pushed=no, deployed/live=not applicable.
```

