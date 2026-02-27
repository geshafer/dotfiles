#!/usr/bin/env bash
# pr-status.sh — fetch all open PRs and their detailed status via GitHub CLI
# Outputs a JSON array of enriched PR objects to stdout.
# Usage: bash pr-status.sh [--pretty]

set -euo pipefail

PRETTY=${1:-""}

stderr() { echo "$*" >&2; }

stderr "🔍 Fetching open PRs for @me..."

PRS=$(gh search prs --author "@me" --state open --limit 50 \
  --json number,title,repository,url,isDraft,createdAt,updatedAt 2>&1)

COUNT=$(echo "$PRS" | jq 'length')
if [ "$COUNT" = "0" ]; then
  stderr "No open PRs found."
  echo "[]"
  exit 0
fi

stderr "📋 Found $COUNT PRs — fetching details..."

RESULTS="[]"

while IFS= read -r pr; do
  number=$(echo "$pr" | jq -r '.number')
  repo=$(echo "$pr" | jq -r '.repository.nameWithOwner')
  stderr "  → $repo #$number"

  detail=$(gh pr view "$number" --repo "$repo" \
    --json number,title,url,isDraft,reviewDecision,mergeStateStatus,\
statusCheckRollup,latestReviews,baseRefName,headRefName,createdAt,updatedAt \
    2>&1)

  # Compute CI summary
  ci_total=$(echo "$detail" | jq '.statusCheckRollup | length')
  ci_failures=$(echo "$detail" | jq '[.statusCheckRollup[] |
    select(.state == "FAILURE" or .conclusion == "FAILURE")] | length')
  ci_pending=$(echo "$detail" | jq '[.statusCheckRollup[] |
    select(.state == "PENDING" or .status == "IN_PROGRESS")] | length')

  if [ "$ci_total" = "0" ]; then
    ci_status="no_checks"
  elif [ "$ci_failures" -gt 0 ]; then
    ci_status="failing"
  elif [ "$ci_pending" -gt 0 ]; then
    ci_status="pending"
  else
    ci_status="passing"
  fi

  # Merge review status into detail
  enriched=$(echo "$detail" | jq \
    --arg ci "$ci_status" \
    --argjson ci_total "$ci_total" \
    --argjson ci_failures "$ci_failures" \
    '. + {ci_status: $ci, ci_total: $ci_total, ci_failures: $ci_failures}')

  RESULTS=$(echo "$RESULTS" | jq --argjson pr "$enriched" '. + [$pr]')

done < <(echo "$PRS" | jq -c '.[]')

if [ "$PRETTY" = "--pretty" ]; then
  echo "$RESULTS" | jq '.'
else
  echo "$RESULTS"
fi
