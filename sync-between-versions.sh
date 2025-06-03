#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# OpenCRVS is also distributed under the terms of the Civil Registration
# & Healthcare Disclaimer located at http://opencrvs.org/license.
#
# Copyright (C) The OpenCRVS Authors located at https://github.com/opencrvs/opencrvs-core/blob/master/AUTHORS.

# defaults, use options to override

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <source_version_dir> <target_version_dir>"
    echo "Example: $0 v1.7.0 v1.8.0"
    exit 1
fi

SRC_DIR="$1"
TARGET_DIR="$2"

# Extract version prefix without ".0" if possible
SRC_VERSION_PREFIX="${SRC_DIR%.*}"
TARGET_VERSION_PREFIX="${TARGET_DIR%.*}"

# Find last commit that touched target version dir
LAST_TARGET_COMMIT=$(git log -1 --format=%H -- "$TARGET_DIR/")

echo "Last $TARGET_DIR commit: $LAST_TARGET_COMMIT"
echo "Files changed in $SRC_DIR since then:"

# List files and process
git diff --name-only "$LAST_TARGET_COMMIT"..HEAD -- "$SRC_DIR/" \
| while read -r file; do
    target_file="$TARGET_DIR/${file#${SRC_DIR}/}"
    echo "Updating: $target_file"
    mkdir -p "$(dirname "$target_file")"
    sed -e "s|$SRC_DIR|$TARGET_DIR|g" \
        -e "s|$SRC_VERSION_PREFIX|$TARGET_VERSION_PREFIX|g" \
        "$file" > "$target_file"
done

echo "Sync from $SRC_DIR to $TARGET_DIR complete."