# Drop-In Agent Rule

Use this as a starting point in a repo `AGENTS.md`, project instruction, or
agent workflow file.

```text
When a request could use broad subagent fanout, first run a read-only cost gate
or ask for the current budget label. Use the label to choose lane count:

- safe: normal bounded fanout, usually 3-5 lanes;
- caution: 2-3 read-only scouts first;
- blocked: direct controller work or one compact scout only;
- unavailable: caution posture unless the task is small and local.

Before dispatch, create one compact controller evidence packet with the request,
constraints, repo state, cost label, proof plan, and stop conditions. Give lanes
only the slice they need. Do not let lanes repeat broad discovery already done
by the controller.

Every lane must return a receipt: scope, files or sources checked, changes,
evidence, skipped checks, risks, and local/committed/pushed/deployed-live
status. The controller owns final integration, verification, and the final done
claim.
```

