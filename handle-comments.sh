#!/bin/bash
set -e
set -x
export spellchecker=${spellchecker:-/app}
. "$spellchecker/common.sh"

echo debug:
cat "$GITHUB_EVENT_PATH"

issue=$(cat "$GITHUB_EVENT_PATH" | jq -r .issue)
number=$(echo "$issue" | jq -r .number)
comment=$(cat "$GITHUB_EVENT_PATH" | jq -r .comment)
username=$(echo "$comment" | jq -r .user.login)
body=$(echo "$comment" | jq -r .body)

body_to_payload() {
  BODY="$1"
  PAYLOAD=$(mktemp)
  echo '{}' | jq --rawfile body "$BODY" '.body = $body' > $PAYLOAD
  rm -f $BODY
  cat $PAYLOAD >&2
  echo "$PAYLOAD"
}

comment() {
  comments_url="$1"
  payload="$2"
  if [ -n "$payload" ]; then
    payload="--data @$payload"
    method="$3"
    if [ -n "$method" ]; then
      method="-X $method"
    fi
  fi
  curl -L -s -S \
    $method \
    -H "Authorization: token $GITHUB_TOKEN" \
    --header "Content-Type: application/json" \
    -H 'Accept: application/vnd.github.comfort-fade-preview+json' \
    $payload \
    "$comments_url"
}

if echo "$body" | grep -q "setup"; then
  COMMENTS_URL=$(echo "$issue" | jq -r .comments_url)
  BODY=$(mktemp)
  base="<details><summary>This is data...</summary>

1
2
3
</details>"
  echo "$base" > $BODY
  PAYLOAD=$(body_to_payload $BODY)
  RESPONSE=$(comment "$COMMENTS_URL" "$PAYLOAD")
  COMMENTS_URL=$(echo "$RESPONSE" | jq -r .url)
  echo "$base

[Quote this line to tell]($COMMENTS_URL) @check-spelling-bot update whitelist" > $BODY
  PAYLOAD=$(body_to_payload $BODY)
  RESPONSE=$(comment "$COMMENTS_URL" "$PAYLOAD" "PATCH")
  echo "$RESPONSE"
  exit 0
fi
trigger=$(echo "$body" | perl -ne 'print if /\@check-spelling-bot(?:\s+|:\s*)update whitelist/')
if [ -n "$trigger" ]; then
  comments_url=$(cat "$GITHUB_EVENT_PATH" | jq -r .repository.comments_url)
  export comments_url=$(echo "$comments_url" | perl -pne 's{\{.*\}}{/\\d+}')
  comment_url=$(echo "$trigger" | perl -ne 'next unless m{($ENV{comments_url})}; print "$1\n";')
  comment=$(comment "$comment_url")
  echo "$comment" | jq -r .body
  echo "trigger? $trigger"
fi
