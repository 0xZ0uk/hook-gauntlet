---
name: hook-gauntlet-round
description: Phase 4 of the hook-gauntlet route for a Uniswap v4 hook - the adversarial loop - brief and launch a discovery or regression audit round on its own bench, read the whole report, reproduce findings, triage (fix at the cause, refuse in writing, accept with a number), verifier passes, the ROUND line, the ceiling, and the loop's exit. Use when NEXT.md gives row 2, 9, 10, 11, 11b, 13, 13b or 14.
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

NEXT.md rows 11 (round 1: a DISCOVERY round), 13 (a REGRESSION round aimed at the diff), 13b (close what is REASONED,
then a discovery round), 11b (a round stopped by the environment), 9 (triage), 10 (a verifier pass for changes with
no bytecode), 2 (the ceiling is reached) and 14 (the loop is over). Model rows spend tokens; each counts against the
ceiling (verifier passes do not).

**Gate (`AGENTS.md` section 3, phase 4):** a DISCOVERY round with zero high and zero medium findings, and no REASONED
high or medium left open. This is a stop rule for spending, not a security claim.

## Read on entry

- ``references/LOOP.md`` - the cycle, why it converges, how to aim the next round, the exit.
- ``references/SEVERITY.md`` - the scale and the exit criterion as a brief states it.
- ``../hook-gauntlet/references/TRIAGE.md`` - the three answers to a finding.
- ``../hook-gauntlet/references/VERIFY.md`` - how to check what comes back, and yourself.

## Steps

1. **Before any round:** the battery is green and the long fuzz has run since the last change (rows 6-7 quiet). If
   not, you are in `hook-gauntlet-battery`, not here.
2. **Write the brief to a file**: `cp `references/audit-round.md` .gauntlet/briefs/rNN.md`; fill the placeholders, do
   not rewrite the rules. DISCOVERY rounds get NO earlier reports; REGRESSION rounds get the diff, the accepted list,
   and the two or three places trusted least (``../hook-gauntlet-interview/references/COST.md`` section 3).
3. **One bench per agent**: ``../hook-gauntlet-battery/scripts/bench.sh` rNN <proj>`. Launch a FRESH agent with the brief's path and the
   bench's path, nothing else - if you are explaining the task in the prompt, the brief is incomplete.
   ``references/ORCHESTRATION.md`` covers models, isolation and what the environment may refuse.
4. **Read the whole report** (its last line is `END OF REPORT rNN`). Too long for your context: read it in sections
   and keep a written ledger. Reproduce every high and medium on your own bench; rerun the auditor's test for each
   low. A high that reproduces goes to the owner NOW (row 1).
5. **Triage each finding** (row 9): fix at the cause / refuse with the reason written into the spec / the owner
   accepts it with a number in `DECISIONS.md`. Owner absent: row 9b, `hook-gauntlet-dossier`. A fix goes through
   ``references/executor-with-gates.md`` when someone else applies it.
6. **After a fix:** the auditor's test inverted into a regression test, seen red on the old code; then the growth
   rule (row 8, `hook-gauntlet-battery`); then the battery and long fuzz again.
7. **Close the round**: one ROUND line at the top of its `LOG.md` entry, written with ``scripts/round.sh``
   (``../hook-gauntlet/references/state/README.md``, "The ROUND line"), carrying the round's effort - a closing round with a thin ROUND line is
   not a closing round. Update `last_audit_round`, `open_findings`, the ceiling's used count.
8. **Row 10** (only documents, comments, scripts or tests changed since the last round): a verifier pass,
   ``references/verifier.md`` - "falsify these sentences" - not a round.
9. **Row 11b:** retry once with a fresh agent and the same brief; stopped again, the round counts as spent and the
   dossier says `not run: stopped at <step>`.
10. **Row 2** (ceiling reached): no more model rounds. Report what was bought, what is open, what the next unit would
    cost; every open finding is triaged or handed to the human audit by name; then promotion or the dossier with
    `ceiling_reached: yes`.
11. **Row 14:** the loop is over. In full mode the closing discovery round runs on a different vendor when one is
    available. Continue at row 15 (`hook-gauntlet-blackbox`).

## Read when

- a claim in a report looks right and you are about to act on it - ``../hook-gauntlet/references/EVIDENCE.md`` (labels, seen red,
  what blocks the exit);
- a mistake feels familiar - ``references/LESSONS.md``, each lesson with the mistake that taught it;
- deciding how much a round may cost, or when to stop - ``../hook-gauntlet-interview/references/COST.md`` sections 3, 5 and 7;
- a hook with earlier review rounds whose reports you do not have (a retrofit) - ``../hook-gauntlet/references/RETROFIT.md``
  section 4: say what is missing; a summary is not a report you read;
- the bench cannot build (no `lib/`) - ``../hook-gauntlet/references/QUICKSTART.md`` steps 1 and 3 and ``../hook-gauntlet-battery/scripts/install-v4.sh``; fetching
  missing dependencies is the owner's decision (`hook-gauntlet-doctor` lists the commands).

## Done when

The row you took is closed and its flags are updated from outputs you read. Run `next.sh`; load the skill its row
names.
