# Who it is for, and what this is not

## Who it is for

Someone who is building a v4 hook and wants it to arrive at a human audit in a state that does not waste the
auditor's time: a falsifiable spec, a green battery, a fuzz campaign, a written record of every trade-off that was
accepted and why, and a list of what was not checked.

You need a Foundry toolchain, an agent runner with a strong orchestrating model, and budget for compute.

## What this is NOT

- **Not a security guarantee.** Passing every gate means "ready for humans to audit". Nothing here certifies that a
  hook is safe.
- **Not a replacement for a human audit.** The effort this method was distilled from went through 28 revisions and
  25 adversarial rounds, and its own authors do not consider it ready without human eyes on it. That is the whole
  point of the route: it is a route *to* an audit.
- **Not an autonomous auditor.** It is a discipline for an agent working with an owner who makes the decisions.
- **Barely benchmarked.** One blind run, one audit round, one small target. See [`status.md`](status.md).

## Limits, stated plainly

- **It depends on a strong orchestrator.** The single highest-leverage part of the method is a well-written brief
  and a full reading of each report. A weak orchestrating model produces rounds that opine instead of measuring.
- **One proof case.** This is distilled from the hardening of one real v4 hook over 28 revisions and 25
  adversarial rounds. One case is one case.
- **Shared blind spots.** Models from the same family miss the same things. The kit recommends that at least one
  round - the verifier or the black-box - runs on a model from a **different vendor**. Nothing in the kit can
  detect a blind spot that every model you use shares.
- **Agent tooling ages fast.** The adapters will rot before the doctrine does. The core is deliberately plain
  Markdown and plain bash so that it outlives them.
- **v4 hooks only.** The method generalises; this version does not. Widening it means replacing the Foundry kit.
