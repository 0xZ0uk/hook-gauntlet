# hook-gauntlet

*From idea to audit-ready, for Uniswap v4 hooks.* Audit-ready means ready to BE audited: a human audit is the next
step, not something this repository replaces or shortens by more than the days an auditor spends asking for what a
dossier should already say.

A repository written for **agents**. You have an idea for a v4 hook, or a hook you already wrote. You give your
agent this repository and your idea. The agent walks a nine-phase route, with a gate at each phase, and the output
is a **dossier for human auditors**.

| you bring | the agent does, with this kit | you end up with |
|---|---|---|
| an idea, or a hook, and the decisions only an owner can make | interviews you, writes a spec that can be proved wrong, builds the tests, runs the local judges (fuzzing, coverage, mutation, the real pool manager of your chain), then adversarial rounds by fresh agents until one finds nothing serious | code that stopped moving, a record of every finding and every trade-off you accepted, and a dossier that tells a human auditor what was tested, how, and **what was not** |

It never deploys anything, never touches a key, and never calls a hook "safe".

> **This process does not measure security. It measures how much of your stated security model you managed to test.**
> It can be confidently wrong when that model is incomplete, when the test oracle is wrong, or when the states that
> were tested exclude the attack. The dossier it produces exists to show a human auditor exactly where the tested
> surface stops.
>
> **Validation status: measured, not validated.** Two blind runs on one small target, twelve walks of the route by
> agents that had never seen it (each on a hook nobody had seen), and a v4 module closed one area at a time with a
> second agent verifying each. All of it with one vendor's models inside one agent harness (Claude Code). Details,
> numbers and limits in [`docs/status.md`](docs/status.md).

Start at [`AGENTS.md`](AGENTS.md). Humans can keep reading here.

## Two minutes

```sh
git clone <this repository> && cd hook-gauntlet
skills/hook-gauntlet-doctor/scripts/selftest.sh              # every guard in scripts/ is made to go RED on purpose, then green. Needs forge and
                                 # skills/hook-gauntlet-battery/foundry-kit/lib (see skills/hook-gauntlet-battery/foundry-kit/README.md); without them it says INCOMPLETE, not PASSED
skills/hook-gauntlet-battery/scripts/battery.sh skills/hook-gauntlet-battery/foundry-kit   # build + tests + sizes + stale-build check on the worked example: one exit code
```

Done looks like this, on forge 1.8.1 (CI also runs 1.8.3):

```
SELFTEST PASSED: every guard went red exactly where it was supposed to.      # 376 cases, about 90 s
test      rc=0   (passed 107, failed 0, skipped 0)  ...  BATTERY PASSED           # the root kit
test      rc=0   (passed 228, failed 0, skipped 0)  suites test=10 test/examples=11 test/sim=15  BATTERY PASSED   # the v4 module, after QUICKSTART step 3
```

The ten-step version, with every command and what "done" looks like at each step, is
[`skills/hook-gauntlet/references/QUICKSTART.md`](skills/hook-gauntlet/references/QUICKSTART.md).

Then, in your own project, to your agent: *"Read `AGENTS.md` in hook-gauntlet, all of it. My idea is: ... Start at
phase 0 and interview me."* From there the agent's next step comes from one decision table,
[`skills/hook-gauntlet/references/NEXT.md`](skills/hook-gauntlet/references/NEXT.md), and everything it decides is written in three files in YOUR repository
(`STATE.md`, `DECISIONS.md`, `LOG.md`), so a different agent - or you - can pick it up cold.

## The route

Nine phases, each with a gate: owner interview, falsifiable spec, hook and battery, then the local judges -
deterministic tools on your own machine, no model - then adversarial rounds by fresh agents, a black-box round
against the compiled artifact without the source, promotion and rehearsal, and finally the handoff dossier. A
model round is only reached when every deterministic tool has nothing left to say, and the dossier always carries
a non-empty list of what was not checked. The full picture and the dossier's nine sections:
[`docs/route.md`](docs/route.md).

## The repository, at a glance

```
AGENTS.md        the agent's entry point: it routes to the resident skill; the canonical text is inside it
docs/            the human-facing documentation: the route, requirements, costs, limits, measured status, prior art
skills/          the whole kit, as Agent Skills - each skill is self-contained: `references/` (doctrine, briefs,
                 state templates, docs) and `scripts/` (the tools its phase runs); `../<sibling>/` for what it
                 shares. `skills/hook-gauntlet-doctor/scripts/install-skills.sh` copies the tree into Claude
                 Code, Codex or Devin; `skills/hook-gauntlet-doctor/scripts/skills-check.sh` is the drift guard
  hook-gauntlet/   the resident skill: the constitution (rules, phases, NEXT.md row -> skill map), AGENTS.md,
                 UPSTREAM, NEXT, EVIDENCE, VERIFY, TRIAGE, RETROFIT, QUICKSTART, the state templates, adapters/
  -interview     the owner interview brief + COST
  -spec          spec template + HOOK-ATTACKS, V4-ACCOUNTING, INVARIANTS, FUZZ-ACTIONS
  -battery       JUDGES, CHANGES, SIMULATE + the judges (battery, fuzz-long, census, bench, mutate, size,
                 assert-fresh-build, fetch-bytecode, install-v4, sim-report) + foundry-kit/ (hostile ERC-20,
                 handler base with campaign census, reusable assertions, a worked vault; v4/ harness for two
                 pool managers, address mining, a hostile hook, a worked dynamic-fee hook)
  -round         LOOP, ORCHESTRATION, SEVERITY, LESSONS + the round briefs (audit, verifier, executor) + round.sh
  -blackbox      the black-box brief
  -release       the promotion brief + release-guard.sh
  -dossier       the handoff-dossier template + dossier-pdf.py
  -doctor        doctor.sh, selftest.sh, skills-check.sh, install-skills.sh + test fixtures
```

## What you need

Foundry, `bash`, `git`, an agent that can read files and run a terminal; Slither for the static-analysis judge in
full mode; Python 3 and Uniswap's pinned sources for parts of the kit. Everything runs on Linux/bash 5 (Windows:
inside WSL). [`skills/hook-gauntlet-doctor/scripts/doctor.sh`](skills/hook-gauntlet-doctor/scripts/doctor.sh) checks each item and prints the install command for
what is missing. The full list, with measured timings and memory: [`docs/requirements.md`](docs/requirements.md). What running the
route costs in tokens: [`docs/costs.md`](docs/costs.md).

## Documentation

| document | contents |
|---|---|
| [`docs/route.md`](docs/route.md) | the route in one diagram; what the handoff dossier contains |
| [`docs/requirements.md`](docs/requirements.md) | toolchain, platforms, hardware; what the v4 module covers vs. what you add |
| [`docs/costs.md`](docs/costs.md) | light vs. full mode and the metered numbers |
| [`docs/limitations.md`](docs/limitations.md) | who it is for, what this is not, limits stated plainly |
| [`docs/status.md`](docs/status.md) | validation status: the kit's own review passes, two blind benchmark runs, twelve fresh-reader walks |
| [`docs/prior-art.md`](docs/prior-art.md) | what this borrows from, and where it came from |

**Status, in one line:** v0 - measured, not validated, on one model family and one agent harness. The numbers and
their limits: [`docs/status.md`](docs/status.md).

## Contributing, security, license

[`CONTRIBUTING.md`](CONTRIBUTING.md) says what a useful contribution looks like (a measured run beats a claim).
[`SECURITY.md`](SECURITY.md) is for a flaw in the kit itself. MIT - see [`LICENSE`](LICENSE). Uniswap's sources are
not part of this repository; `skills/hook-gauntlet-battery/scripts/install-v4.sh` fetches them, and they keep their own licences.
