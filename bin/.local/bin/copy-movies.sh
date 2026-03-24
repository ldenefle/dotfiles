#!/usr/bin/env bash

# -------- CONFIG --------
SOURCE_DIR="${HOME}/Downloads"
REMOTE_HOST="tramontane"
DEST_DIR="/storage/movies"
LOG_FILE="${HOME}/.local/var/log/recent_rsync.log"

# Time window (in minutes)
MINUTES=300
# ------------------------

# Find files modified in the last hour and rsync them
pushd $SOURCE_DIR && \
find . -type f -mmin "-$MINUTES" -print0 | \
rsync -avP --remove-source-files --files-from=- --from0 \
"$SOURCE_DIR/" \
"${REMOTE_HOST}:${DEST_DIR}/" \
 && \
popd
