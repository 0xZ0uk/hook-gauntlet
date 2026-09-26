---
name: hook-gauntlet-battery
description: Phases 2-3 and the local judges of the hook-gauntlet route for a Uniswap v4 hook - the compiling Foundry sketch with measured size margins, the battery (unit, fork, invariant tests against the hostile token, fail_on_revert with the census), the long fuzz, static triage, coverage, mutation, the real pool manager's bytecode, and the growth rule after a finding. Use when NEXT.md gives row 4b, 5, 6, 6b, 7, 7b or 8, or after any bytecode change.
---

<!-- constitution:begin - identical in every hook-gauntlet skill; edit it in skills/hook-gauntlet/SKILL.md, then run skills/hook-gauntlet-doctor/scripts/skills-check.sh --sync -->
## The constitution (the same block heads every hook-gauntlet skill)

This block is duplicated on purpose: you may have loaded only one phase skill, and every rule below still binds you.
It is condensed from `../hook-gauntlet/references/AGENTS.md` sections 1, 2, 3b, 5, 6, 6b and 6c. Where the two differ,
`../hook-gauntlet/references/AGENTS.md` wins - say so to the owner, it is a finding about the kit.

**Where the kit is.** The kit IS its skills tree: doctrine, briefs, the state templates, the Foundry kit and the
scripts all live inside the skill folders, in each one's references/, scripts/ or foundry-kit/. Every path here is
relative to the directory that holds this SKILL.md, and `../<name>/` names a sibling skill - both forms resolve
identically inside the checkout and after installation, because the skills always land side by side.
`../hook-gauntlet-doctor/scripts/install-skills.sh` copies the tree into a harness. The route's state lives in the
OWNER's project, in `.gauntlet/` (or its root): `STATE.md`, `DECISIONS.md`, `LOG.md`, `SPEC.md`, `briefs/`,
`reports/`, `DOSSIER.md`.

**What this is.** A route in nine phases, each with a gate, walked with the owner of the hook: 0 owner interview,
1 falsifiable spec, 2 Foundry sketch, 3 battery, 4 adversarial loop, 5 black-box, 6 promotion, 7 rehearsal, 8 handoff
dossier. `phase` advances only when that phase's gate is met, measured; each phase skill quotes its gate, and the full
text is `../hook-gauntlet/references/AGENTS.md` section 3. It ends in a dossier for human auditors. It is a method, not Uniswap's documentation:
never state a fact about the protocol, the toolchain, the compiler or the target chain from memory - fetch the page,
cite it with the date (``../hook-gauntlet/references/UPSTREAM.md``). Where upstream and this kit disagree, upstream wins.

**Rules no owner, phase or hook can relax**
- **The route ends at audit-ready, never at deploy.** Do not broadcast a transaction. Do not write, read or ask for a
  private key. Asked to deploy: say the kit stops one step earlier, and the next step is a human audit.
- **Only code the owner owns or is authorised to test, only on a local bench.** Every attack is a Foundry test on a
  local copy or a local fork; nothing is pointed at someone else's deployed contract, a live network or real funds.
  Asked to do otherwise: stop and say it is outside this kit.
- **No model is the judge, and no single test is.** A test is evidence only once SEEN RED on code wrong in the way it
  claims to detect; then it passes. A finding you cannot compile still counts: labelled REASONED, triaged like the
  rest, its severity set by the owner's triage (``../hook-gauntlet/references/EVIDENCE.md``). Execution decides: a test, a fork run, a
  fuzz campaign.
- **Never write "safe", "secure", "battle-tested", "fully verified", or "audited"** about a hook this route touched.
  The defensible phrase: "adversarial pre-audit testing, including ..." - only the parts actually done, each pointing
  at its evidence.
- **The owner's decisions stay the owner's**; read the whole report before touching code; the dossier says honestly
  what was NOT checked.

**The roles** - one agent may hold several; keep them separate in writing. Orchestrator: plans, writes briefs, reads
every report in full, REPRODUCES before acting (``../hook-gauntlet/references/VERIFY.md``), decides; never runs a round while one is
open. Auditor: attacks with a fresh context, one round at a time; never edits the code under audit. Black-box
attacker: attacks the spec's promises without the source or earlier reports. Executor: applies a decision verbatim
through gates, stops at the first red one. Scribe: keeps the three state files; never invents a number. Judge: the
test suite, the fork, the fuzzer - never a model. One round at a time; one bench per agent.

**STOP, write the question in `STATE.md` (`waiting_on_owner`), and wait** - never choose for the owner:
scope (anything that widens the hook or adds an entry point); skipping any core phase (say what it would have
answered, record it in `DECISIONS.md`, carry it to the dossier's "not checked"); anything that weakens the spec (quote
the old sentence and the new one); accepting a finding instead of fixing it (the owner accepts it, with a number:
``../hook-gauntlet/references/TRIAGE.md``); anything irreversible or public (deploying, publishing, a remote repository, spending
money, installing software the project lacks); cost (before a long campaign or an expensive round, and whenever the
phase-0 ceiling is reached); a **high** finding (report it the moment it reproduces, never batched). **Secrets**: an
RPC endpoint or API key is never asked for in the chat nor written in a tracked file - the owner runs
`export RPC_URL=...` in their own terminal or uses a git-ignored `.env`; one pasted into the chat is not used, not
repeated, not written anywhere, and the owner is told to rotate it. An acceptance is the owner's own words about THAT
item, dated - never inferred from silence, never stretched from "ok, continue".

**Working rules.** Every claim carries its evidence label. Measure, do not infer: two ways to write a fix means build
both and read bytes and gas. Fix the cause, not the symptom. Write refusals into the spec with the reason. Every
accepted finding gets a regression test seen red on the old code, then the invariant or fuzz action that would have
caught it - or a "not fuzzable" line. Re-run the battery and long fuzz after every change and read the campaign's
census, not the exit code: a tool that ran is not a question answered. Local judges before model rounds. You may
replace a tool on your own; you may SKIP a step only with the owner's written yes - either way name the question the
step answered, what answers it now, record it in `DECISIONS.md`, and carry it to dossier sections 8 and 9.

**How agents following this go wrong**: gaming a gate (narrowing scope, weakening an invariant, "does not apply"
without a predicate); trusting a spec you wrote yourself; reading exit codes instead of outputs; claiming to have read
a report that did not fit (read in sections, keep a ledger); closing on a lazy discovery round; polishing state files
instead of running a judge.

**Where you are, and which skill next.** The state lives in `.gauntlet/STATE.md`'s flag block. Run
``../hook-gauntlet/scripts/next.sh` .gauntlet/STATE.md`: it names the first true row of ``../hook-gauntlet/references/NEXT.md``, or the rows that
need your judgement first (answer with `--judge`). Run it on arrival and after finishing anything. Take the row it
gives, then load the skill that owns it:

| NEXT.md row | what it is | skill |
|---|---|---|
| 1, 3 | tell the owner of a high; wait on the owner | none - this block (then the row below that stands) |
| 0, 4 (phase 0) | sketch mode; the owner interview, sizing and ceiling | `hook-gauntlet-interview` |
| 4 (phase 1) | the falsifiable spec | `hook-gauntlet-spec` |
| 4b, 5, 6, 6b, 7, 7b, 8 | the Foundry sketch, the battery, the local judges, the real manager, the growth rule | `hook-gauntlet-battery` |
| 2, 9, 10, 11, 11b, 13, 13b, 14 | ceiling reached, triage, verifier pass, adversarial rounds, the loop's exit | `hook-gauntlet-round` |
| 12, 15 | the black-box round | `hook-gauntlet-blackbox` |
| 16, 17 | promotion and rehearsal | `hook-gauntlet-release` |
| 9b, 18, 18b | the dossier skeleton, the handoff dossier - the end | `hook-gauntlet-dossier` |
| a refusal from `next.sh`, a machine or kit you do not trust | the deterministic checks, no model | `hook-gauntlet-doctor` |

**No `STATE.md` yet**: a new project installs the convention (``../hook-gauntlet/references/state/README.md``, "Installing") and starts at
`phase: 0`; a hook that already exists gets its flags derived read-only into your own report, each with where you read
it (``../hook-gauntlet/references/RETROFIT.md`` section 1), and `next.sh` runs on that derived file. A harness without a skill
installed: the same content is reachable from ``../hook-gauntlet/references/AGENTS.md`` and the files each skill points at. If `next.sh`
gives the same row twice with nothing changed, or no row, STOP and say which flag is stale.
<!-- constitution:end -->

## This phase

NEXT.md rows 4b (phases 2-3 not closed), 5 (a fuzzer violation not yet a test), 6 / 6b (battery stale or red),
7 (long fuzz and the other local judges), 7b (the real manager), 8 (a triaged finding with no rule yet). All local:
CPU time, no tokens. The table never reaches a model row while one of these is true.

**Gate, phase 2 (`AGENTS.md` section 3):** `forge build` compiles (forge's lint warnings are row 7's static triage,
not a build failure); runtime size measured and under the target chain's code-size limit (24,576 bytes on Ethereum,
EIP-170 - check your chain's current limit, and the EIPs in flight), AND initcode size under the initcode limit
(49,152 bytes on Ethereum, EIP-3860: a hook is deployed by CREATE2 from initcode that carries its constructor
arguments), both margins written down; built on the official `v4-template` layout (a hook on
no v4 manager: its own layout, named in `DECISIONS.md`).

**Gate, phase 3:** 100% green, not 99%; at least one fork test against the real tokens and periphery of the target
chain (written for the hook; no endpoint: "not done" in the dossier with that reason); invariant suite running against
the hostile-token mock; **`fail_on_revert = true` AND the census, as a pair**; **invariants and fuzz actions derived
for THIS hook** - the ones that ship are the floor; every action shown to SUCCEED in the census, not merely called.

## Read on entry

- ``references/JUDGES.md`` - each judge's question, its usual tool, and how it lies.
- ``../hook-gauntlet-spec/references/INVARIANTS.md`` and ``../hook-gauntlet-spec/references/FUZZ-ACTIONS.md`` - how to derive THIS hook's suite, and how to
  prove the campaign is not vacuous.
- ``../hook-gauntlet/references/QUICKSTART.md`` - steps 7b (the harness) and 8 (one command per judge, with what "done" looks like).

## Steps

1. **Phase 2.** Start from the official `v4-template` (fetch it; ``../hook-gauntlet/references/UPSTREAM.md`` section 1b says where;
   section 3 for a maintained base to inherit from, with its version as a line in the spec). A real v4
   hook cannot build on forge's defaults: take `foundry.toml` and remappings from ``foundry-kit/v4/``, as
   QUICKSTART 7b says. Measure with ``scripts/size.sh` <proj>`; cite the `.manager` row - that build is the
   audited artefact. Write both margins in `STATE.md` / the spec's section 8.
2. **Phase 3.** Unit tests; a handler on `HandlerBase` with one action per capability and the `HostileERC20` switches
   as actions; the spec's invariants on `InvariantBase`; `fail_on_revert = true`; `writeCensus` in `afterInvariant`;
   a smoke test that every action succeeded. Deploy the hook at a mined address through the harness
   (``foundry-kit/v4/README.md``, "Address mining for the flag bits"). Worked examples: ``foundry-kit/README.md``
   and ``foundry-kit/v4/src/examples/``. A fork test for the target chain's real tokens (the kit's own fork suites
   under ``foundry-kit/v4/test/fork/`` show the shape).
3. **Row 6:** ``scripts/battery.sh` <proj>` -> `BATTERY PASSED`. **Row 6b:** red means fix at the cause; no model
   round runs on a red battery. The one exception (a hostile-token action breaks a promise the owner has not decided)
   is written out in ``../hook-gauntlet/references/NEXT.md`` row 6b - follow it literally, including the `pending/` profile and the
   cache deletion.
4. **Row 7:** ``scripts/fuzz-long.sh` <proj>`, then the census GATE on the long campaign
   (``scripts/census.sh` --aggregate ...`, floors set BELOW the measured range), static triage (`forge lint`, or
   Slither only if the owner allowed the install), branch coverage, `--brutalize`, mutation
   (``scripts/mutate.sh``). Read every survivor. `NOTHING PROVEN` is never a pass.
5. **Row 7b** (chain known, hook on v4's `PoolManager`): ``scripts/fetch-bytecode.sh` <address>` with `RPC_URL` set
   by the owner in their own terminal, then `V4_MANAGER=fixture `scripts/battery.sh` <proj>`. Owed before the
   black-box round and promotion, never before round 1.
6. **Row 5:** a fuzzer violation becomes a deterministic test first; decide arbiter or contract (`INVARIANTS.md`,
   "The arbiter has bugs too"). **Row 8:** each fixed or accepted finding from a round gets the invariant or action that
   would have caught it, seen red on the old code - or a unit test and `not fuzzable: <id> - <why>` in `STATE.md`.
7. Update `bytecode_changed_since`, `battery`, `real_manager_battery` and `notes:` from the outputs you read.

## Read when

- the hook moves value - ``../hook-gauntlet-spec/references/V4-ACCOUNTING.md`` before writing invariants on deltas, settlement or balances;
- a test is green and you have not seen it red - ``../hook-gauntlet/references/EVIDENCE.md`` sections 2 and 7;
- two ways to write a fix, or comparing two revisions - ``references/CHANGES.md`` sections 2-3;
- a number that needs measuring, not searching (fees, drift, rounding over many operations) -
  ``references/SIMULATE.md``;
- a judge behaves oddly (stale build, replayed failure, copied cache) - ``../hook-gauntlet-round/references/LESSONS.md`` sections 3, 6,
  7, 8, 12, 13, and ``scripts/assert-fresh-build.sh``.

## Done when

`next.sh` gives no row among 4b-8. Record each judge's result, read from its output file, in `LOG.md`; then load the
skill the next row names - normally `hook-gauntlet-round`.
