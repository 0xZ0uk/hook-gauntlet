# Changelog

## Unreleased - the core as a resident constitution + on-demand phase skills (issue #2)

- `skills/` IS the repository now: nine Agent Skills, each self-contained. `hook-gauntlet` is resident and carries
  the constitution - the rules of the canonical `references/AGENTS.md` condensed, and the NEXT.md row -> skill map.
  Eight phase skills (`-interview`, `-spec`, `-battery`, `-round`, `-blackbox`, `-release`, `-dossier`, `-doctor`)
  each open with the SAME constitution block, on purpose: an agent that loaded only one phase skill still has the
  scope rule.
- What a skill needs lives inside it: doctrine, briefs and templates under `references/`, the tools its phase runs
  under `scripts/`, the Foundry assets under `foundry-kit/` (the battery skill). What it shares with the others is a
  `../<sibling>/` relative path away - so `<kit>/` placeholders are gone, and installing the skills is a plain copy:
  `skills/hook-gauntlet-doctor/scripts/install-skills.sh`, verified by running the drift guard on the installed tree.
- `skills/hook-gauntlet-doctor/scripts/skills-check.sh` is the drift guard: one constitution byte-identical
  everywhere, every relative pointer resolves, every `references/` file is pointed at by a SKILL.md, the router
  names every skill, identical `scripts/lib/` files stay byte-identical, and backticked dead-path prefixes
  (`doctrine/`, `briefs/`, `scripts/`, `foundry-kit/`, `state/`) are refused. `--sync` re-stamps the constitution
  copies from the resident. Self-test cases make each check go red.
- The root `doctrine/`, `briefs/`, `state/`, `scripts/`, `foundry-kit/` and `adapters/` directories are gone - their
  contents live inside the skills. Root `AGENTS.md` is a stub that routes to the resident skill; the canonical
  text is `skills/hook-gauntlet/references/AGENTS.md`, and where any file and it disagree, it still wins.

## v0.1.1 - 2026-09-25 - the dossier as a PDF, and what a handoff must be

- `scripts/dossier-pdf.py` renders the handoff dossier as a PDF for the human auditor (status lines boxed first,
  tables with wrapped cells and repeated headers, nothing dropped); QUICKSTART step 10 hands over `DOSSIER.md` and
  `DOSSIER.pdf`, the Markdown being the record. Needs `reportlab` (optional); CI renders the template on every push.
- A handoff, as opposed to an exercise, now requires a git repository with its commit on the dossier's first line,
  every judge output cited from inside the project, and section 10 runnable on a clean machine (the kit vendored into
  the project with relative remappings).
- The DeltaFeeHook campaign's intermittent red in CI was the test harness, not the hook: a test router that kept an
  unused prepayment, and a handler that misread a correct refusal. Both fixed, pinned as replays, verified.

## v0.1 - 2026-09-24 - pre-audit workflow for Uniswap v4 hooks

First public release. Measured on one model family (Claude) inside one agent harness (Claude Code): two blind runs on one
small planted-defect target, twelve walks of the route by agents that had never seen it, each on a hook nobody had seen,
and a v4 module closed one area at a time with a second agent verifying each area. Numbers and limits: `docs/status.md`.

Worked examples in `foundry-kit/v4/`, each with unit, invariant, mutant and edge tests:

- an ordinary before/after hook with a capped dynamic fee (`CappedDynamicFeeHook`);
- a hook that returns deltas - fee on the unspecified side, rebate on the specified side, a per-pool cap (`DeltaFeeHook`);
- native-currency pools in the router and the liquidity helper, with a hostile native counterparty;
- a hook that keeps its fee as ERC-6909 claims, with conservation per party (`ClaimsFeeHook`);
- settlement re-entrancy through a token's own transfer, every manager door (`TokenCallbackActor`);
- a second pool sharing a currency, and state per pool;
- a 60-swap edge grid per hook at tick spacing 1 and 32 767 and at the price limits.

Not covered, said in `docs/status.md` and in the module's own gap list: fork tests and a block-pinned fixture; a JIT-recipient
actor for hooks that pay "whoever is in range"; v4-periphery; the token behaviours `foundry-kit/README.md` lists.

The route ends at audit-ready. It never deploys, never broadcasts, never handles a key, and never calls a hook safe.
