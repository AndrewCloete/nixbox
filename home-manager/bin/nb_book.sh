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


NB_DIR="/Users/user/Workspace/journals/notebook/obsidian_nb"
BOOK_DIR="${NB_DIR}/TOC/Books"


MULTILINE_STRING="""---
authors:
${AUTHORS}
date: ${DATE}
ISBN: ${ISBN}
---

#Books
Subtitle: ${SUBTITLE}

"""

FILE="${BOOK_DIR}/${TITLE}.md"
if [ -f "$FILE" ]; then
    echo "Error: File '$FILE' already exists. Exiting."
    exit 1
fi

echo $MULTILINE_STRING
echo "${MULTILINE_STRING}" > "${FILE}"


exit 0
