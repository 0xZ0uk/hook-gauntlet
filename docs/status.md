# Status

**v0, 2026-09-24. Two blind runs on one small target; twelve fresh-reader walks of the route, the last seven with a
real discovery round each; the v4 module's gap list closed except fork tests. One model family, one agent harness.**

| part | state |
|---|---|
| doctrine, briefs, state convention | distilled from a real project, then walked twelve times by strangers on twelve new hooks (below); every stall they hit is fixed, and each fix was re-walked |
| Foundry kit and scripts | written with their own tests (hostile token: one test per switch; guards: a self-test that makes each one go red on purpose). Scripts exercised on bash 5 / Linux only |
| v4 module | harness with both managers, address mining, three worked hooks with unit, invariant, mutant and edge tests; proven once against the Ethereum mainnet manager's bytecode. **Covered:** delta-returning hooks, native currency with a hostile native counterparty, ERC-6909 claims with conservation per party, settlement re-entrancy through a token's transfer hook, a second pool sharing a currency, tick/price/fee edges (all 2026-09-24, each area verified by a second agent - below). **Not covered:** fork tests and a block-pinned fixture; a JIT-recipient actor for hooks that pay "whoever is in range"; v4-periphery (its README, "What this module still does not do") |
| `skills/hook-gauntlet/references/adapters/claude-code.md` | the path the method was actually run on |
| `skills/hook-gauntlet/references/adapters/codex.md` | **experimental / untested** - written from the documented convention, kept out of the supported path until an end-to-end run exists |
| blind benchmark (planted bugs, sealed answer key, measured recall) | **run twice on the same target**: one round, then the full light route - see below |
| review of the kit itself | three audit passes, twelve fresh-reader walks, five verifier passes over the v4 series - see below. **Same model family as the authors, one agent harness; no human has reviewed this kit** |

### The kit, put through its own loop

Each pass was a fresh model instance, on a frozen tree (a manifest of hashes checked before and after), forbidden to
read the authors' notes, and told to assume the previous fixes were wrong.

Severity here is the kit's own scale for a repository of Markdown and bash: **high** = a gate that passed when it
should have failed, **medium** = a guard that could be beaten or a fix that opened a door, **low** = wording and numbers.

| pass | high | medium | low + informative | what it was mostly about |
|---|---|---|---|---|
| 1 - independent audit | 3 | 9 | 19 | **false greens in the gate scripts themselves**: a battery that passed with zero tests, a mutation script that said KILLED on any error, a long fuzz that passed with no campaign |
| 2 - verifier, over the fixes | 0 | 4 | 15 | two doors **the fixes had opened** (one script could now delete the project it was asked to copy); a "campaign census" that was really one run in 64 |
| 3 - verifier, over those fixes | 0 | 0 | 12 | the same path guard, beaten twice more by odd paths; nine sabotages the self-test did not notice |

All fixed, and since pass 2 every fix arrives with the case that sees it red first (`skills/hook-gauntlet/references/VERIFY.md` 11b). The
numbers fall; they have not reached zero, and the pattern is worth more than the count: **the Solidity held, the
bash around it did not.** Anything here that parses a tool's human-readable output is the part to trust least.

### The blind benchmark, run 1

An agent wrote a ~440-line limit-order hook with six planted defects (2 high, 3 medium, 1 low), one red herring, a
spec and a green battery of 20 tests, and sealed the answer key. Two fresh agents, each alone on an isolated bench
with this kit and one brief, ran **one audit round**. Neither could see the key or the other.

| | normal audit brief | brief that reasons backwards from the harm |
|---|---|---|
| planted defects found (recall against the key) | 6 / 6 | 6 / 6 |
| findings emitted in total | 12 (6 planted + 4 beyond the key + 2 informative) | 11 (6 + 3 + 2) |
| false alarms among those adjudicated | none found; 2 of arm A's extras were not adjudicated | none found |
| red herring | dismissed, with a test | dismissed, with a test |
| real findings beyond the key, confirmed afterwards by reading the source | 1 high, 1 medium (+2 unadjudicated) | 2 high, 1 low |
| tokens / wall clock | 269k / 28 min | ~230k / ~20 min |

Read this for what it is:

- **n = 1, one small target, one round.** The spec phase, the fuzz growth loop, the black-box round and promotion were
  not exercised. The route as a whole is still unmeasured.
- **The target was too easy to separate the two briefs.** Both hit the ceiling, so the comparison is undecided.
- **Planter and auditors were the same model family.** A blind spot they share is invisible in this result.
- The planter did not know about the two extra high-severity bugs. An answer key written by a model is a floor.
- One arm built the invariant suite on its own and reported that five of its twelve findings were a missing fuzz
  *action*, not a missing invariant - which is what `skills/hook-gauntlet-spec/references/FUZZ-ACTIONS.md` says, confirmed from outside.

### The blind benchmark, run 2 - the full route, two models

Same target and sealed key as run 1. Two fresh agents entered by `skills/hook-gauntlet/references/QUICKSTART.md` with nothing else, played the owner,
and walked the **light route** - interview, spec review, local judges, the simulation sandbox, up to three model rounds,
the dossier skeleton - each on its own bench.

| | strong model (Opus 5.5) | cheaper model (Sonnet) |
|---|---|---|
| planted defects found | 6 / 6 | 6 / 6 |
| planted highs, rated high | 1 of 2 (one rated medium: "nobody profits") | 2 of 2 |
| red herring | not raised | not raised |
| the two real highs beyond the key (known since run 1) | both (one rated medium) | both, rated high - found by the **black-box** round, without the source |
| model rounds used, of 3 | 1 (discovery) | 3 (discovery found 3 of 6; black-box and verifier found the rest) |
| tokens | ~265k | at least ~545k (one round's usage was not returned) |
| simulation sandbox | run, shipped agents | run |

Read this for what it is:

- **The route lifted the cheaper model to the same score; the strong one needed one round of it.** That is the first
  measurement of what the route adds, and it is one run per arm.
- **The target was already scored once**, and the key was written by a model of the same family as both auditors.
- **The second arm's isolation is self-declared**: the orchestration harness gave every agent one shared scratch
  directory, and the first arm's tests were in it while the second ran. The second arm and its sub-agents declared
  they did not read it; that cannot be proved, so the result is labelled indicative. (The rule it produced is
  `skills/hook-gauntlet-round/references/ORCHESTRATION.md` §1.)
- **A harder target was not built**: the model provider's safety classifier stopped the agent asked to write a hook
  with planted defects, twice. The next target comes from public hooks with public fixes (`ORCHESTRATION.md` §4).
- Both arms left a list of places where the kit was wrong or silent. The fixes are in the commits after this run;
  whether a fresh reader still stalls at those steps is the next measurement, not a claim made here.

### Twelve walks by strangers

After run 2, the question changed from "does an auditor find the bugs" to "does a stranger get through the route
without guessing". Each walk was a fresh agent given `skills/hook-gauntlet/references/QUICKSTART.md` and nothing else, on a hook it wrote for the
purpose (a capped desk, a surge-fee pool, a budget gate, an impact guard, a cooldown gate, a tip jar, a swap-reward pot,
a claims escrow, a bonded-swap gate, a milestone escrow, a referral skim, a donate-back hook - the last four real v4
hooks, the last with a delta and ERC-6909 claims on native pools), owner played from the project's files, token
behaviours left undecided on purpose. Each recorded every step as clean, guessed or stalled; the orchestrator fixed
what it named and the next walk re-walked it.

| walks | what they stalled on, in order | state after the fix |
|---|---|---|
| 2-3 | the sandbox did not compile on forge's defaults; a freshness guard red once in ten for no reason; holes in the decision table | the guard asks forge itself; the table has a row for phase 3 and for an absent owner |
| 4-5 | binding the sandbox changed the audited bytecode (1374 -> 727 B) with no flag moving | the sandbox lives in its own forge profile; measured byte-identical before and after |
| 6-9 | where the auditor's tests compile, which campaign the census gate judges, the long-fuzz budget on forge's defaults, a whole missing step (building the harness) | step 7b exists; the gate judges the long campaign and leaves a record |
| 10 | "nothing false in the tools" - three doctrine guesses | fixed |
| 11-13 | a real v4 hook has no project recipe; coverage under the manager's IR restriction measured the wrong build; a hook that pays "whoever is in range" has no recipient check | recipe in 7b; `--ir-minimum` mandatory there; class 20 names the JIT recipient - the actor is the module's next gap |

Every walk ended with "no": a stranger still had to guess somewhere. What shrank is what they guessed at - from a
sandbox that would not compile to a sentence about who counts a pending row. The last four walks reported every
script doing what its document said. No walk was on a hook anyone had seen before; no walk was on a hook that exists
in production.

### The v4 module, closed one area at a time

The module's own list of what it did not do was closed in four agent passes (deltas; native currency and claims;
settlement re-entrancy, a second pool, the edges; and the fold-ins), each followed by a verifier agent with fresh
context and its own tests, told to falsify. What the verifiers did:

- confirmed the four-orientation accounting at the wei from raw balances, the re-entry tables, the mutant tables;
- **broke one claim**: "a position of an LP that refuses ETH is stuck, not lost" - a stranger could remove it and keep
  the money, because the fixture's liquidity helper owned every position; fixed (positions per caller);
- **found what the authors had not**: forge clears transient storage between top-level calls, so a unit suite never
  sees two swaps in one transaction (a mutant survived on that alone); a token callback paying with its own claims
  bypassed a check and left a rebate as nobody's; a hook's `settle` mid-payment against a router that pays what it
  still owes is theft, visible only to books kept per party; state kept per currency let a stranger's pool drain
  another pool's rebates while conservation per currency stayed green.

The v4 battery went from 108 to 228 tests. `skills/hook-gauntlet-spec/references/V4-ACCOUNTING.md` carries the measured items (13-24) and four
rules; `skills/hook-gauntlet-spec/references/HOOK-ATTACKS.md` names the test file for every class the module exercises.

### How all of this was run, and what is next

Every agent above ran inside **one harness, Claude Code, on one vendor's models**: Opus 5.5 as the workers, verifiers
and strangers; Sonnet as the cheaper arm of run 2; Fable 5.1 deciding doctrine, reading reports, and never certifying
its own work (`skills/hook-gauntlet-round/references/ORCHESTRATION.md`). That is the single largest limit of every number on this page: a blind spot
shared by that family and that harness is invisible here.

The next measurement is therefore **another vendor and another harness**: an open-weights model run locally inside an
agent harness of a different lineage, given this repository and a hook, with the orchestrator asking it to walk the
gauntlet as the owner would - the same score sheet as the walks above (steps clean / guessed / stalled, findings against
a sealed key). It also removes two things that shaped the runs here: a provider-side safety classifier that stopped
agents asked to author planted defects (and once a plain discovery round), and a harness that refuses report-named
files. Until that run exists, the route is measured on one family and one harness.

Until there is a run on another vendor's model and another harness, treat the claims in this repository as a
description of a method measured on one family, with the numbers above.

Issues and confirmations are useful. The most useful thing you can send is a run of the route on a hook we did not
write: the step where you stalled or guessed, the attack that was missing, the test that turned out vacuous, the mutant
that survived, and what the human auditor found afterwards. [`CONTRIBUTING.md`](../CONTRIBUTING.md) says how; [`SECURITY.md`](../SECURITY.md) is for a flaw in
the kit itself.
