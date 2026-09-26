---
name: hook-gauntlet-spec
description: Phase 1 of the hook-gauntlet route for a Uniswap v4 hook - write the falsifiable SPEC.md - decide every attack class in HOOK-ATTACKS.md with its predicate, the hostile-actor table over every external entry point, invariants and fuzz actions in words, assumptions and out-of-scope. Use when NEXT.md gives row 4 with phase 1, when a spec row cannot be falsified, or before the black-box round to walk the attack classes again.
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

NEXT.md row 4 while `phase: 1`. You produce `.gauntlet/SPEC.md` (a project with its own `SPEC.md` keeps it; the
route's spec links to it rather than copying). Every later phase is aimed by this document: a line that cannot fail is
not a promise.

**Gate (`AGENTS.md` section 3, phase 1):** every class in `references/HOOK-ATTACKS.md` is decided (applies / does not
apply, with its predicate / accepted / prevented by an admission rule); the assumptions the spec stands on are listed;
the "what a hostile actor can do -> what the contract answers" table covers every external entry point; invariants are
written in words; out-of-scope is explicit; the owner has read it (absent: `waiting_on_owner`, as in phase 0).

## Read on entry

- ``references/spec-template.md`` - the shape; copy it to `.gauntlet/SPEC.md` and fill it.
- ``references/HOOK-ATTACKS.md`` - baseline PROMPTS, not a taxonomy and not coverage.
- ``../hook-gauntlet/references/EVIDENCE.md`` - section 6: "does not apply" is a claim, and it gets attacked.

## Steps

1. Section 1-2 from the interview (`.gauntlet/briefs/00-interview.md`, `DECISIONS.md`): what it is, the principle.
2. **Every class in `HOOK-ATTACKS.md`, one line each**: applies / does not apply (with the predicate the spec states,
   e.g. "the hook holds no tokens") / accepted (the owner's, with a number) / prevented by an admission rule. A
   "does not apply" without a predicate is gaming the gate.
3. **Section 3, the hostile-actor table**: one row per external entry point - including every hook callback the
   permission bits enable - and what the contract answers. Enumerate the entry points from the code or the design, not
   from memory.
4. **Sections 4 and 4b, invariants and fuzz actions in words**, derived backwards from the damage
   (``references/INVARIANTS.md``, "Derive them backwards"; ``references/FUZZ-ACTIONS.md``, "The five questions").
   Phase 3 turns each into code; write them so each could go red.
5. Section 5 (admission rules), 5b (**the assumptions the spec stands on** - every one is a target for a later
   round), 6 (accepted trade-offs, each with a number, each the owner's), 7 (out of scope, explicit).
6. **The security framework's triggered features.** The phase-0 self-score names which of the Uniswap Foundation
   framework's features this hook triggers; each one becomes a line the spec answers (``../hook-gauntlet/references/UPSTREAM.md``
   section 2). No self-score yet: fetch the framework, list the triggers the code matches, and leave the score to the
   owner (`waiting_on_owner`).
7. **Protocol facts** (deltas, settlement, flags, native currency, return values) are fetched from upstream and cited
   with the date, never recalled: ``../hook-gauntlet/references/UPSTREAM.md`` section 1b is the topic table.
8. Give it to the owner to read. Any sentence they change that WEAKENS a promise: quote old and new, and get their yes
   (`EVIDENCE.md` section 4).

## Read when

- the hook moves value - takes, settles, holds tokens, returns deltas, touches native currency or claims: read
  ``references/V4-ACCOUNTING.md`` in full before writing sections 3-4. It is long on purpose; do not skim it to save
  tokens. A hook that only reads state or gates access may skip it, and says so in `DECISIONS.md`;
- you are walking the classes again before the black-box round - `HOOK-ATTACKS.md` header says when;
- a later round's finding makes you want to edit a sentence rather than the code - ``../hook-gauntlet/references/NEXT.md``,
  "Fix the code or fix the sentence?".

## Done when

Every item of the gate is met and the owner has read it (or `waiting_on_owner: spec read` is set). Update `STATE.md`
`phase: 2`, log it, run `next.sh`, and load the skill its row names - normally `hook-gauntlet-battery`.
