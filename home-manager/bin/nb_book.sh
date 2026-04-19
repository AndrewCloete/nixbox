#!/bin/bash

if [ -z "$1" ]; then
    usage
fi

ISBN="$1"

BOOK_DATA=$(curl "https://openlibrary.org/api/books?bibkeys=ISBN:${ISBN}&format=json&jscmd=data")



echo $BOOK_DATA | jq

get_key() {
    echo $BOOK_DATA | jq -r ".[\"ISBN:${ISBN}\"].$1"
}


TITLE=$(get_key "title")
SUBTITLE=$(get_key "subtitle")
# The filter: wrap name in brackets, wrap that in escaped quotes, then join with commas
AUTHORS=$(get_key "authors[] | \"- \\\"[[\" + .name + \"]]\\\"\"")
DATE=$(get_key "publish_date")
YEAR=$(echo "$BOOK_DATA" | jq -r --arg key "ISBN:${ISBN}" '
  .[$key].publish_date // ""
  | (match("(18|19|20)[0-9]{2}") | .string) // empty
')
YEAR_YAML=""
if [ -n "$YEAR" ]; then
    YEAR_YAML="year: ${YEAR}"$'\n'
fi

SUBTITLE_YAML=""
if [ -n "$SUBTITLE" ] && [ "$SUBTITLE" != "null" ]; then
    SUBTITLE_YAML="subtitle: ${SUBTITLE}"$'\n'
fi

NB_DIR="/Users/user/Workspace/journals/notebook/obsidian_nb"
BOOK_DIR="${NB_DIR}/external/blog/reference/library/books"

MULTILINE_STRING="$(
    cat <<EOF
---
title: ${TITLE}
${SUBTITLE_YAML}authors:
${AUTHORS}
date: ${DATE}
${YEAR_YAML}ISBN: ${ISBN}
---

EOF
)"

FILE="${BOOK_DIR}/${TITLE}.md"
if [ -f "$FILE" ]; then
    echo "Error: File '$FILE' already exists. Exiting."
    exit 1
fi

echo $MULTILINE_STRING
echo "${MULTILINE_STRING}" > "${FILE}"


exit 0
