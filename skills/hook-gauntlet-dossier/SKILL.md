---
name: hook-gauntlet-dossier
description: Phase 8 of the hook-gauntlet route for a Uniswap v4 hook - write the handoff dossier for human auditors (or its skeleton when findings wait on the owner) - what the judges said read from outputs, every divergence, a non-empty list of what was NOT checked, reproducible numbers, and the PDF reading copy. The end of the route. Use when NEXT.md gives row 9b, 18 or 18b.
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

NEXT.md row 18 (promoted, and rehearsed if applicable), row 18b (light mode: the loop is over and the owner declined
promotion in writing) and row 9b (open findings wait on an absent owner's triage: write the SKELETON, then stop and
wait). **This is the end of the route.** The next step is human.

**Gate (`AGENTS.md` section 3, phase 8):** every "must" section filled or marked "not done" with a reason; what the
judges said, read from outputs; every divergence; a non-empty list of what was **not** checked; a fresh agent can
reproduce the numbers from the dossier alone. The template's own gate, at its end, is part of it (a handoff names its
commit on the first line, cites judge outputs from inside the project, and has section 10 runnable on a clean machine).

## Read on entry

- ``references/handoff-dossier.md`` - the template; every "must" section, in order.
- ``../hook-gauntlet/references/EVIDENCE.md`` - the labels every claim in the dossier carries, and section 3, what blocks the exit.

## Steps

1. `cp `references/handoff-dossier.md` .gauntlet/DOSSIER.md`; fill it from the project's own records -
   `DECISIONS.md`, `LOG.md` (its ROUND lines), `.gauntlet/reports/`, the judges' output files. **Every number is read
   from an output file and cited by path**, never from memory or a summary.
2. **Section 6, what the judges said** - one row per judge in ``../hook-gauntlet-battery/references/JUDGES.md``, each "done" with its output
   or "not done" with the reason. Light mode (18b): promotion and rehearsal are "not done: light mode, owner's
   decision", and section 9 says what promotion would have added.
3. **Section 8, where you diverged** - every tool you replaced and every step the owner let you skip, from
   `DECISIONS.md`.
4. **Section 9, what was NOT checked** - never empty: classes the fuzzer cannot reach (economic, deployment,
   assumptions about external systems), every `not fuzzable:` note, judges not run, the limits of one model family.
   The auditor reads this first.
5. **Section 10, reproduce it** - commands a fresh agent on a clean machine can run; a kit reached by absolute path is
   said so.
6. **Row 9b skeleton**: each open finding listed by id in section 4 with `open - owner triage pending`; sections 0, 4,
   5, 6, 7, 8, 9 honest; `waiting_on_owner: triage of <ids>` in `STATE.md`; STOP. A dossier with open findings is a
   status report, not a handoff. Row 2 (ceiling reached): write `ceiling_reached: yes` in the status line.
7. **Words**: none of the forbidden words above. Describe only what was done, each with its evidence.
8. Reading copy: `python3 `scripts/dossier-pdf.py` .gauntlet/DOSSIER.md` (needs `reportlab`; without it, exit 2 and
   the Markdown goes alone - it stays the record either way).

## Read when

- sizing what to say about cost and what the kit does not know - ``../hook-gauntlet-interview/references/COST.md`` section 8;
- a simulation ran - ``../hook-gauntlet-battery/references/SIMULATE.md`` section 5 says what goes in;
- the project was retrofitted, or its spec is in another language - ``../hook-gauntlet/references/RETROFIT.md`` sections 2 and 4.

## Done when

The gate is met, `STATE.md` says `dossier: complete (N judges not done)`, and you tell the owner the route has ended:
the dossier goes to human auditors. **STOP.** Never `forge script --broadcast`, never `cast send`.
