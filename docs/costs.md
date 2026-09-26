# Honest costs

Compute is the real cost. Two modes:

| mode | phases 4 and 5 |
|---|---|
| **light** | 3 adversarial rounds + 1 black-box |
| **full** | rounds until a discovery round closes with zero high and zero medium findings and nothing reasoned is left open, plus a black-box round and a verifier round. Open-ended: the effort this was distilled from took 25 rounds |

**We do not publish a price**, but here is the arithmetic from the one round we metered: about 250k tokens and half
an hour per round on a 440-line hook, so a light-mode run (a ceiling of 4) is on the order of a million tokens of round
traffic, once, n = 1, before the orchestrator's own reading. We did not meter the project this was distilled from, and a kit whose first rule is
"measure, do not infer" is not going to dress that up as a price list. The ROUND line of each `LOG.md` entry records the real cost of each of
your rounds. The one number we have measured is in [`status.md`](status.md).

The long fuzz campaign is the other cost, and it is CPU time, not model spend: expect tens of minutes per run.

