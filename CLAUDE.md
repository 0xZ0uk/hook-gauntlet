# CLAUDE.md

This project's instructions for agents live in **[`AGENTS.md`](AGENTS.md)**. Read it in full before doing anything.

If you are Claude Code, also read **[`skills/hook-gauntlet/references/adapters/claude-code.md`](skills/hook-gauntlet/references/adapters/claude-code.md)**: it maps the
roles in `AGENTS.md` to subagents and models, and shows how to launch a round.

Two rules that override anything else you infer from this repository:

- The route ends at **audit-ready**. Never deploy, never broadcast, never handle a private key.
- No model is the judge, and no single test is either: a test counts as evidence only once it has been seen to FAIL on
  broken code, and a finding you cannot compile still counts, labelled REASONED (`skills/hook-gauntlet/references/EVIDENCE.md`).
