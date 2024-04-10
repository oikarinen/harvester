#!/bin/bash

set -euo pipefail

GITHUB_USERNAME="$USER"
GITHUB_LABEL="foo"
GITHUB_DATE="2024-01-01"
HARVEST_PROJECT="1234"
HARVEST_TASK="4321"
TASK_MIN_HOURS=2
TASK_MAX_HOURS=8

SEARCH_CRITERIA="is:issue assignee:${GITHUB_USERNAME} is:closed label:${GITHUB_LABEL} closed:>${GITHUB_DATE}"

which gh || echo "Please install gh: 'brew install gh'" && exit 1
which hrvst || echo "Please install hrvst-cli: 'npm install -g hrvst-cli'" && exit 1

hrvst login

for TASK_DATE in $(gh issue list --limit 100 --search "$SEARCH_CRITERIA" --json closedAt --jq '.[].closedAt | split("T")[0]'); do
  HOURS=$((TASK_MIN_HOURS + RANDOM % (TASK_MAX_HOURS - TASK_MIN_HOURS + 1)))
  hrvst time-entries create --project_id "$HARVEST_PROJECT" --task_id "$HARVEST_TASK" --spent_date "$TASK_DATE" --hours "$HOURS"
done
