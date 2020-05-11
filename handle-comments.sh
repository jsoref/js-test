#!/bin/bash
set -e
export spellchecker=${spellchecker:-/app}
. "$spellchecker/common.sh"

echo debug:
cat "$GITHUB_EVENT_PATH"

number=$(cat "$GITHUB_EVENT_PATH" | jq -r .issue.number)
comment=$(cat "$GITHUB_EVENT_PATH" | jq -r .comment)
username=$(echo "$comment" | jq -r .user.login)
body=$(echo "$comment" | jq -r .body)

trigger=$(echo "$body" | perl -e '$/=undef; $_=<>; print 1 if /\@check-spelling-bot(?:\s+|:\s*)update whitelist/')
if [ -n "$trigger" ]; then
  echo "trigger? $trigger"
fi
