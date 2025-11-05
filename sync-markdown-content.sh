#!/usr/bin/env bash
# Usage: ./sync-markdown-content.sh <source_dir> <target_dir>
#
# Description:
#   - Recursively loops through the source directory.
#   - If a markdown file (.md) exists in both source and target, replaces the target file content.
#   - If any file (of any type) or directory exists in source but not in target, creates or copies it.
#   - Ignores hidden files and directories (starting with .).

set -euo pipefail

SRC="${1:-}"
DEST="${2:-}"

if [ -z "$SRC" ] || [ -z "$DEST" ]; then
  echo "Usage: $0 <source_dir> <target_dir>"
  exit 1
fi

if [ ! -d "$SRC" ]; then
  echo "❌ Source directory not found: $SRC"
  exit 1
fi

mkdir -p "$DEST"

echo "📂 Source: $SRC"
echo "📁 Target: $DEST"
echo "============================================================="

# --- 1️⃣ Ensure all directories from source exist in target ---
find "$SRC" -type d ! -path "*/.*" | while read -r SRC_DIR; do
  REL_PATH="${SRC_DIR#$SRC/}"
  DEST_DIR="$DEST/$REL_PATH"

  if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
    echo "📁 Created directory: $REL_PATH"
  fi
done

# --- 2️⃣ Copy or replace files ---
find "$SRC" -type f ! -path "*/.*" | while read -r SRC_FILE; do
  REL_PATH="${SRC_FILE#$SRC/}"
  DEST_FILE="$DEST/$REL_PATH"

  # Ensure destination directory exists (redundant but safe)
  mkdir -p "$(dirname "$DEST_FILE")"

  if [ -f "$DEST_FILE" ]; then
    if [[ "$SRC_FILE" == *.md ]]; then
      cp "$SRC_FILE" "$DEST_FILE"
      echo "🔄 Replaced markdown: $REL_PATH"
    else
      echo "⚙️ Skipped existing non-markdown file: $REL_PATH"
    fi
  else
    cp "$SRC_FILE" "$DEST_FILE"
    echo "🆕 Copied new file: $REL_PATH"
  fi
done

echo "============================================================="
echo "🎯 Done syncing."
