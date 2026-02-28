#!/bin/bash
# Deploy MySQL to Snowflake demo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_CONFIG="$SCRIPT_DIR/../../core/scripts/config.sh"

source "$CORE_CONFIG"

if [ -n "$SNOWFLAKE_CONNECTION" ]; then
    SNOW_CONN="--connection $SNOWFLAKE_CONNECTION"
else
    SNOW_CONN=""
fi

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         Demo: MySQL to Snowflake                             ║"
echo "╚══════════════════════════════════════════════════════════════╝"

# Setup demo tables
echo "Creating target tables..."
snow sql $SNOW_CONN -f "$SCRIPT_DIR/snowflake/setup_demo.sql"

# Build MySQL image
echo "Building MySQL image..."
cd "$SCRIPT_DIR/mysql"
docker build --platform linux/amd64 -t mysql-spcs:latest .

REPO_URL=$(snow sql $SNOW_CONN -q "SHOW IMAGE REPOSITORIES IN SCHEMA ${SNOWFLAKE_DATABASE}.${SNOWFLAKE_SCHEMA}" 2>/dev/null | grep -i "NIFI_REPO" | awk -F'|' '{print $3}' | tr -d ' ' | head -1)
FULL_IMAGE="${REPO_URL}/mysql-spcs:latest"
docker tag mysql-spcs:latest $FULL_IMAGE
docker push $FULL_IMAGE

cd "$SCRIPT_DIR"

# Create service
echo "Creating MySQL service..."
snow sql $SNOW_CONN -f "$SCRIPT_DIR/snowflake/create_services.sql"

echo "Demo deployed! Configure NiFi to query MySQL."
