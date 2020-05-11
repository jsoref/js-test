#!/bin/bash
# This CI acceptance test is based on:
# https://github.com/jsoref/spelling/tree/04648bdc63723e5cdf5cbeaff2225a462807abc8
# It is conceptually `f` which runs `w` (spelling-unknown-word-splitter)
# plus `fchurn` which uses `dn` mostly rolled together.
set -e
export spellchecker=${spellchecker:-/app}
. "$spellchecker/common.sh"

if [ -z "$GITHUB_EVENT_PATH" ] || [ ! -e "$GITHUB_EVENT_PATH" ]; then
  GITHUB_EVENT_PATH=/dev/null
fi
case "$GITHUB_EVENT_NAME" in
  schedule)
    exec "$spellchecker/check-pull-requests.sh"
    ;;
  issue_comment|pull_request_review_comment)
    exec "$spellchecker/handle-comments.sh"
    ;;
esac
exit 1
