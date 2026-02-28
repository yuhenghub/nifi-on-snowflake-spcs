#!/bin/bash
# Deploy Kafka to Snowflake demo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_CONFIG="$SCRIPT_DIR/../../core/scripts/config.sh"

# Load core config
source "$CORE_CONFIG"

if [ -n "$SNOWFLAKE_CONNECTION" ]; then
    SNOW_CONN="--connection $SNOWFLAKE_CONNECTION"
else
    SNOW_CONN=""
fi

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         Demo: Kafka to Snowflake                             ║"
echo "╚══════════════════════════════════════════════════════════════╝"

# Setup demo tables
echo "Creating target tables..."
snow sql $SNOW_CONN -f "$SCRIPT_DIR/snowflake/setup_demo.sql"

# Build and push Kafka image
echo "Building Kafka image..."
cd "$SCRIPT_DIR/kafka"
docker build --platform linux/amd64 -t kafka-spcs:latest .

# Get repo URL
REPO_URL=$(snow sql $SNOW_CONN -q "SHOW IMAGE REPOSITORIES IN SCHEMA ${SNOWFLAKE_DATABASE}.${SNOWFLAKE_SCHEMA}" 2>/dev/null | grep -i "NIFI_REPO" | awk -F'|' '{print $3}' | tr -d ' ' | head -1)
FULL_IMAGE="${REPO_URL}/kafka-spcs:latest"
docker tag kafka-spcs:latest $FULL_IMAGE
docker push $FULL_IMAGE

# Build and push data generator
echo "Building data generator..."
cd "$SCRIPT_DIR/data-generator"
docker build --platform linux/amd64 -t data-generator:latest .
FULL_IMAGE="${REPO_URL}/data-generator:latest"
docker tag data-generator:latest $FULL_IMAGE
docker push $FULL_IMAGE

cd "$SCRIPT_DIR"

# Create services
echo "Creating Kafka and data generator services..."
snow sql $SNOW_CONN -f "$SCRIPT_DIR/snowflake/create_services.sql"

echo "Demo deployed! Configure NiFi to consume from Kafka."
