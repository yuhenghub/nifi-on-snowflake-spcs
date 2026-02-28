#!/bin/bash
# Cleanup NiFi SPCS resources

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Build snow CLI connection parameter
if [ -n "$SNOWFLAKE_CONNECTION" ]; then
    SNOW_CONN="--connection $SNOWFLAKE_CONNECTION"
else
    SNOW_CONN=""
fi

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              NiFi SPCS Cleanup                               ║"
echo "╚══════════════════════════════════════════════════════════════╝"

read -p "This will delete all NiFi SPCS resources. Continue? (y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Cancelled."
    exit 0
fi

echo "Running cleanup..."
snow sql $SNOW_CONN -f "$SCRIPT_DIR/../snowflake/99_cleanup.sql"

echo "Cleanup complete!"
