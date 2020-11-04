#!/bin/bash
echo entrypoint.sh
echo APP_DIR: ${APP_DIR}
echo HOST_APP_DIR: ${HOST_APP_DIR}
set -e

# Remove a potentially pre-existing server.pid for Rails.
if test -f "$APP_DIR/tmp/pids/server.pid"; then
    rm -f $APP_DIR/tmp/pids/server.pid
fi
# rm -f $APP_DIR/tmp/pids/server.pid
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
