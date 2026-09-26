# The route

The nine-phase route, in one picture. `AGENTS.md` is the agent-facing entry point; the canonical text is
[`skills/hook-gauntlet/references/AGENTS.md`](../skills/hook-gauntlet/references/AGENTS.md).

## In one picture

```mermaid
flowchart TD
    IDEA(["An idea for a v4 hook"]) --> MOVING{"Is the design<br/>still moving?"}
    MOVING -- "yes" --> SKETCH["SKETCH MODE<br/>local judges only, no model rounds"]
    SKETCH --> MOVING
    MOVING -- "no" --> P0["0 - Owner interview<br/>scope, threat model, non-goals,<br/>light or full mode, ceiling"]
    P0 --> P1["1 - Falsifiable spec<br/>hostile actor -> the contract's answer<br/>baseline attack prompts, each one DECIDED,<br/>plus the assumptions the spec stands on"]
    P1 --> P2["2-3 - Hook + battery<br/>unit tests, invariants, hostile token,<br/>size measured"]
    P2 --> LOCAL

    subgraph LOCAL["LOCAL JUDGES - deterministic tools on the owner's machine, no model. Each answers ONE question"]
        direction LR
        J1["build, lints,<br/>static analysis<br/>with a written triage"] --> J2["tests +<br/>long fuzz,<br/>corpus on"] --> J3["coverage<br/>by branch +<br/>campaign census"] --> J4["mutation:<br/>do the tests bite?<br/>read the survivors"] --> J5["the REAL pool<br/>manager of<br/>your chain"]
    end

    P1 -. "an economic promise<br/>needs a NUMBER first" .-> SIM["SIMULATION SANDBOX - optional<br/>a named population, a stated ordering model,<br/>numbers that are SUPPORTED, never a gate"]
    P6 -. "before promotion,<br/>parameters sealed" .-> SIM
    SIM -.-> P1
    LOCAL -. "tool does not fit this hook?" .-> DIV["Answer the QUESTION another way<br/>and write it down.<br/>Questions are fixed, tools are not"]
    DIV -.-> LOCAL

    LOCAL --> WHAT{"All quiet.<br/>What changed since<br/>the last model round?"}
    WHAT -- "bytecode" --> ROUND["4 - Adversarial round<br/>fresh agent, own bench.<br/>DISCOVERY (no earlier reports) or REGRESSION (the diff)"]
    WHAT -- "1-2 rounds done,<br/>black-box never run" --> BB["5 - Black-box, EARLY<br/>bench WITHOUT the source: the attacker<br/>RUNS tests against the compiled artifact"]
    WHAT -- "only documents or tests" --> VER["Verifier pass<br/>cheap: falsify these sentences"]

    ROUND --> READ["Read the WHOLE report<br/>a test counts only once SEEN RED;<br/>a finding that cannot compile still counts"]
    BB --> READ
    VER --> READ

    READ --> CLEAN{"A DISCOVERY round closed with<br/>0 high and 0 medium, nothing REASONED<br/>left open, nothing changed since?"}
    CLEAN -- "no" --> TRIAGE["Triage each finding:<br/>fix at the CAUSE / refuse in writing /<br/>accept with a number - the OWNER decides"]
    TRIAGE --> GROW["Growth rule: add the invariant and the<br/>fuzz action that would have caught it"]
    GROW --> LOCAL

    CLEAN -- "yes" --> P6["6-7 - Promotion and rehearsal<br/>canonical copy, hash manifest, drift guard,<br/>runbook followed by another agent"]
    P6 --> P8["8 - Handoff dossier<br/>what the judges said, every divergence,<br/>and what was NOT checked"]
    P8 --> HUMAN(["HUMAN AUDIT<br/>the kit stops here: it never deploys"])
    P6 -. "any bytecode change reopens the release" .-> LOCAL

    classDef local fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20
    classDef model fill:#fff3e0,stroke:#ef6c00,color:#e65100
    classDef owner fill:#e3f2fd,stroke:#1565c0,color:#0d47a1
    classDef stop fill:#fce4ec,stroke:#ad1457,color:#880e4f
    classDef note fill:#f5f5f5,stroke:#9e9e9e,color:#424242,stroke-dasharray: 4 3
    class SKETCH,J1,J2,J3,J4,J5,SIM local
    class ROUND,BB,VER model
    class P0,TRIAGE owner
    class HUMAN stop
    class DIV note
```

Green runs locally: deterministic tools on your own CPU, no model involved. Orange is a round run by a model, and
spends tokens - so the table in [`skills/hook-gauntlet/references/NEXT.md`](../skills/hook-gauntlet/references/NEXT.md) never
reaches an orange box while a green one still has something to say. Blue is the owner's decision, never the agent's.
The grey box is the rule that keeps this from being a checklist: **the questions are fixed, the tools are not**
([`AGENTS.md`](../AGENTS.md) section 6b, [`skills/hook-gauntlet-battery/references/JUDGES.md`](../skills/hook-gauntlet-battery/references/JUDGES.md)).

## What comes out at the end

The handoff dossier ([`skills/hook-gauntlet-dossier/references/handoff-dossier.md`](../skills/hook-gauntlet-dossier/references/handoff-dossier.md)), assembled from files the route already
produced. Its sections, because they say more about this kit than any description of it:

1. **Scope sheet** - the exact commit, files in and out of scope, compiler and its known bugs, sizes, bytecode hashes,
   deployment parameters, trusted periphery, tokens supported, who holds which key.
2. **What it is and what it promises** - the hostile-actor table: what an attacker can do, what the contract answers,
   the test that proves it, the fuzz action that reaches it, the mutant that test was seen to kill. Empty cells stay empty.
3. **Access control** - every entry point, who may call it, what happens to everyone else.
4. **Known issues and accepted trade-offs** - each with a number, and who accepted it.
5. **What the judges said** - one row per tool, with the result read from its output, not from its exit code.
6. **The adversarial history** - every round, what it found, what was done about it.
7. **Where we diverged from the usual process**, and why.
8. **What was NOT checked** - the section an auditor reads first. It may not be empty.
9. **Reproduce it** - the commands that regenerate the numbers above.

## What is in the kit

- **Doctrine** - the adversarial loop that makes successive audits converge instead of circling: one round at a
  time, read the whole report, fix the cause, write down the refusals, regression-test everything, re-measure.
  Plus: a decision table for "what do I do next", the eleven judges (ten deterministic tools and the simulation sandbox)
  with the question each one answers and how each one lies, what counts as evidence and how an agent fools itself, baseline prompts for things that go wrong in v4 hooks, how to derive your own invariants and fuzz actions, and when
  the agent may diverge from all of it.
- **Briefs** - parameterised templates for each role: audit round, verifier, black-box attacker, executor with
  gates, promotion, owner interview, spec, and the handoff dossier a human auditor reads.
- **A state convention** - three files in your project (`STATE.md`, `DECISIONS.md`, `LOG.md`) so an
  agent with no context can read them and continue.
- **A Foundry kit** - a hostile token mock with per-wallet switches, an invariant skeleton with a call-and-success
  census, and a worked toy example. The v4 module (`skills/hook-gauntlet-battery/foundry-kit/v4/`) runs one suite against two pool managers - compiled from source, or the real
  bytecode of the one deployed on your chain - mines the hook address for its permission bits, and ships a small
  worked hook.
- **Scripts** - full battery, long fuzz, the campaign census (what the fuzzer actually reached, added up over every
  run), per-agent bench, publication guard, aimed mutants and variants, sizes, the pinned Uniswap sources, the real
  bytecode of the pool manager on your chain - and a self-test that makes every one of those guards go red on purpose.
- **Adapters** - a thin layer per tool. The core is plain Markdown and plain bash and depends on no vendor feature.

