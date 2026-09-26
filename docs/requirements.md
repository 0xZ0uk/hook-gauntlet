# Requirements

## What you need

[`skills/hook-gauntlet-doctor/scripts/doctor.sh`](../skills/hook-gauntlet-doctor/scripts/doctor.sh) checks everything below and prints the install command for each missing item; it installs nothing.

Foundry, `bash`, `git`, and Python 3 if you can (standard library only: the freshness guard uses it for the evidence
it prints - which source changed since the last build; without it that evidence is missing, the verdict is forge's either
way), and an agent that can read files and run a terminal; Slither (Python) for the static-analysis
judge, which full mode requires and which is an install your agent must ask you for; `reportlab` (Python), optional, for the
PDF copy of the dossier only (`skills/hook-gauntlet-dossier/scripts/dossier-pdf.py`; without it the dossier is handed over as Markdown alone). `forge install foundry-rs/forge-std`
in `skills/hook-gauntlet-battery/foundry-kit/` before the self-test (it says INCOMPLETE without it). The v4 module needs Uniswap's
sources: `skills/hook-gauntlet-battery/scripts/install-v4.sh` fetches them at pinned commits into a git-ignored `lib/` (or, offline, copies local
clones and checks the same pins: `V4_LOCAL_SRC`, `skills/hook-gauntlet-battery/foundry-kit/v4/README.md`). They are not in this
repository and must not be - `PoolManager` is BUSL-1.1. The scripts are exercised on Linux
and bash 5. **On Windows, run everything inside WSL** and keep the project on the Linux side: paths, line endings
(`CRLF` breaks a shell script silently) and file watchers all behave differently across the boundary. macOS is
untested.

**Hardware.** Any 64-bit machine; a slow one is only slower. Measured on an 8-core / 16-thread desktop, memory as the
peak above idle:

| step | time | memory |
|---|---|---|
| base kit: clean build / its test suite | 1.9 s / 1.2 s | 0.3 GB / 0.1 GB |
| v4 module: clean build, which compiles Uniswap's `PoolManager` with `via_ir` | 26 s | **1.3 GB** |
| v4 module: its test suite, either manager | 3 s | 0.1 GB |
| v4 module: coverage | 29 s | 1.3 GB |
| mutation of a 260-line hook, 16 parallel jobs | 1 min | **5.3 GB** |
| the same, `--mutation-jobs 1` | 30 min | 0.9 GB |
| invariant campaign, 64 000 fuzzed calls, small example | 13 s | negligible |

So: 8 GB is comfortable, 4 GB works if you keep mutation to one or two jobs, and mutation is the step that trades
memory for time almost linearly. The expensive part of this kit is not your machine, it is the model behind your
agent. On Windows, WSL sees half of the machine's memory by default.

## What the v4 module covers, and what your project must add

| covered by an example here | project-specific, yours to add |
|---|---|
| hooks with no delta; hooks that return deltas; native ETH pools; ERC-6909 claims; a second pool sharing a currency; settlement re-entrancy through a token; dynamic fees; per-pool reserves; price and tick edges; hostile tokens and hostile native counterparties | fork tests on the target chain; the real manager's bytecode for that chain; unusual periphery; rebasing tokens and the other token behaviours `skills/hook-gauntlet-battery/foundry-kit/README.md` lists as not covered; who receives a payout (a JIT-recipient actor); your hook's own threat model, actions and invariants |

