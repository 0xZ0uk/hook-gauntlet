# Prior art

This is not the first attempt to put adversarial pressure on a contract before a human sees it, and it borrows
from all of these:

- **"Weird ERC-20" repositories** - the catalogues of token behaviours that break integrations (fee on transfer,
  rebasing, missing return values, revert on zero, blocklists). The hostile-token mock in `skills/hook-gauntlet-battery/foundry-kit/` is a
  switchable version of that idea, and the catalogues are a better checklist than anything an agent will invent.
- **DeFi CTFs and wargames** - the tradition of learning a protocol by breaking a deliberately vulnerable copy of
  it. Phase 4 is that tradition with the copy replaced by your own code.
- **Uniswap's own material, which comes first**: the [v4 developer docs](https://developers.uniswap.org/docs/protocols/v4/overview)
  and the Uniswap Foundation's [Hook Security Framework](https://developers.uniswap.org/docs/protocols/v4/security) - a
  self-scored risk tier that says how much outside assurance a hook is expected to have. The owner scores the hook in
  phase 0 and the dossier reports against it. [`skills/hook-gauntlet/references/UPSTREAM.md`](../skills/hook-gauntlet/references/UPSTREAM.md) lists what to read before
  believing anything here, and says that where upstream and this kit disagree, upstream wins.
- **The official [`v4-template`](https://github.com/uniswapfoundation/v4-template)** - phase 2 starts from it, not
  from a layout of ours. If the template changes, follow the template.
- **Foundry's invariant testing and `forge fuzz`** - the judge in this kit is Foundry. The doctrine is mostly a set
  of rules about how to read its output honestly.
- The published audit-report conventions of the human audit firms, for the shape of a finding: severity, who
  loses, cost to the attacker, fix, and the test that proves it - and their audit-readiness guides, from which the
  dossier's "must" rows were taken (the research notes behind it are not in this repository; the guides themselves
  are a web search away and the dossier template says which rows are theirs).
- Most of this repository is packaging of those four sources for an agent. What outside reviewers agreed was new:
  the rule that a test counts only once seen red, the campaign census, "questions fixed, tools free", the mandatory
  "not checked" section, and the catalogue in `skills/hook-gauntlet-battery/references/JUDGES.md` of how each tool lies.

## Origin

Distilled from the hardening of one real Uniswap v4 hook across 28 revisions and 25 adversarial rounds. The project
itself is not identified, and no line of its code and none of its mechanics are in this repository. A few measurements
of TOOL COST taken on it appear in `skills/hook-gauntlet-battery/references/JUDGES.md`, marked as coming from "a real hook" (mutant counts, run times);
nothing about the contract itself does. What is here is the method.
