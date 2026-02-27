---
name: pr-status
description: Check the status of all open GitHub pull requests authored by the user across all repos. Shows review decision, CI status, merge state, draft status, and recommended next action for each PR. Use when asked about open PRs, what PRs need attention, PR review status, or anything about pull request state.
---

# PR Status

Fetches all open PRs authored by `@me` across all GitHub repos and presents a formatted summary.

## Run

```bash
bash ~/bin/pr-status.sh
```

The script uses `gh search prs` and `gh pr view` to collect data and outputs a JSON array of enriched PR objects — one per open PR — each with a `ci_status` field (`passing`, `failing`, `pending`, `no_checks`) computed from `statusCheckRollup`.

## Present Results

After running the script, present two sections:

### 1. Narrative summary — grouped by urgency

- 🔴 **Needs immediate action** — CI failing, merge conflict, changes requested
- 🟡 **Waiting on something** — review required, stacked on another PR
- 🟢 **Ready** — approved + CI green, or clean merge state
- 🔵 **Parked** — drafts, old spikes

### 2. Full summary table

| PR | Repo | Title | Draft | Review | CI | Merge | Action |
|----|------|-------|-------|--------|----|-------|--------|
| [#N](url) | owner/repo | Title | Yes/No | ✅/⏳/❌ | ✅/❌/🔄/⚪ | 🟢/🔴/🟡/❓ | What to do |

## Key

**Review** (`reviewDecision`):
- `APPROVED` → ✅ Approved
- `CHANGES_REQUESTED` → ❌ Changes Requested
- `REVIEW_REQUIRED` → ⏳ Review Required
- `""` → N/A

**CI** (use `ci_status` from script output):
- `passing` → ✅ Passing
- `failing` → ❌ Failing (`ci_failures` has the count)
- `pending` → 🔄 Pending
- `no_checks` → ⚪ No checks

**Merge** (`mergeStateStatus`):
- `CLEAN` → 🟢 Ready to merge
- `DIRTY` → 🔴 Conflict — needs rebase
- `UNSTABLE` → 🟡 Unstable
- `BLOCKED` → 🔴 Blocked by branch protection
- `UNKNOWN` → ❓ Unknown (often stacked or draft)

**Stacked PRs:** if `baseRefName` is not `main`/`master`/`trunk`, note the dependency.
