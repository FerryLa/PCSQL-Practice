#!/usr/bin/env bash
set -e
DAY="${1:-$(date +%Y-%m-%d)}"
Y=${DAY:0:4}; M=${DAY:5:2}; D=${DAY:8:2}
BASE="solutions/$Y/$M/$D"
mkdir -p "$BASE/python" "$BASE/sql" "$BASE/java"
touch "$BASE/python/.keep" "$BASE/sql/.keep" "$BASE/java/.keep"
echo "Created $BASE"
