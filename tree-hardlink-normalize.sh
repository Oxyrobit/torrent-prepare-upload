#!/bin/bash
set -Eeuo pipefail
# Basic checks
if [ $# -ne 1 ]; then
    echo "Usage: $0 <source_directory>"
    exit 1
fi

SRC="$(realpath "$1")"

if [ ! -d "$SRC" ]; then
    echo "The provided path is not a directory."
    exit 1
fi

PARENT="$(dirname "$SRC")"
BASENAME="$(basename "$SRC")"
NEW_BASENAME="$(echo "$BASENAME" | tr ' ' '.')"
DST="$PARENT/$NEW_BASENAME"

if [ -e "$DST" ]; then
    echo "The destination directory already exists: $DST"
    exit 1
fi

echo "Preview of operations to be performed:"
# Directory creation
find "$SRC" -type d | while read -r dir; do
    rel="${dir#$SRC/}"
    [ "$dir" = "$SRC" ] && continue
    new_rel="$(echo "$rel" | tr ' ' '.')"
    echo "$DST/$new_rel"
done

read -p "This script will create a new directory with file and directory names without spaces. Do you want to continue? (Y/N) " choice
if [[ "$choice" != "Y" && "$choice" != "y" ]]; then
    echo "Operation cancelled."
    exit 1
fi

mkdir "$DST"

find "$SRC" -type d | while read -r dir; do
    rel="${dir#$SRC/}"
    [ "$dir" = "$SRC" ] && continue
    new_rel="$(echo "$rel" | tr ' ' '.')"
    mkdir "$DST/$new_rel"
done

# Hardlink creation
find "$SRC" -type f | while read -r file; do
    rel="${file#$SRC/}"
    new_rel="$(echo "$rel" | tr ' ' '.')"
    target="$DST/$new_rel"

    if [ ! -e "$target" ]; then
        ln "$file" "$target"
    fi
done
