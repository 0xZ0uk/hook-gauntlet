# AGENTS.md - hook-gauntlet

The route for taking a Uniswap v4 hook from an idea to audit-ready lives in **`skills/`** as Agent Skills.

- Start here: `skills/hook-gauntlet/SKILL.md` - the resident skill; it routes you to the phase skill you need.
- The canonical text it condenses: `skills/hook-gauntlet/references/AGENTS.md` - read it in full before touching
  anything; where any other file and it disagree, it wins.
- Install the skills into a harness: `skills/hook-gauntlet-doctor/scripts/install-skills.sh --harness claude|codex|devin|agents`
- Check this machine and this tree: `skills/hook-gauntlet-doctor/scripts/doctor.sh` and `.../skills-check.sh`.

Two rules that override anything else you infer from this repository:

- The route ends at **audit-ready**. Never deploy, never broadcast, never handle a private key.
- No model is the judge, and no single test is either: a test counts as evidence only once it has been seen to FAIL
  on broken code, and a finding you cannot compile still counts, labelled REASONED
  (`skills/hook-gauntlet/references/EVIDENCE.md`).
