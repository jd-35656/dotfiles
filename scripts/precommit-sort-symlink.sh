#!/usr/bin/env bash
set -euo pipefail

SYMLINK_FILE="symlink.json"

if [[ ! -f "$SYMLINK_FILE" ]]; then
  echo "No $SYMLINK_FILE found, skipping."
  exit 0
fi

tmpfile=$(mktemp)

jq 'to_entries
  | sort_by(.key)
  | map({ key: .key, value: (.value | to_entries | sort_by(.key) | from_entries) })
  | from_entries' "$SYMLINK_FILE" > "$tmpfile"

mv "$tmpfile" "$SYMLINK_FILE"
git add "$SYMLINK_FILE"

echo "✅ symlink.json sorted and staged"
