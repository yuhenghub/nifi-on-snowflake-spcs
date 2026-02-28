#!/bin/bash
# One-click deployment script for NiFi on SPCS

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Load configuration
source "$SCRIPT_DIR/config.sh"

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         Apache NiFi on Snowflake SPCS - Deployment           ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Build snow CLI connection parameter
if [ -n "$SNOWFLAKE_CONNECTION" ]; then
    SNOW_CONN="--connection $SNOWFLAKE_CONNECTION"
else
    SNOW_CONN=""
fi

# Function to run SQL
run_sql() {
    local sql_file="$1"
    echo -e "${YELLOW}Running: $sql_file${NC}"
    snow sql $SNOW_CONN -f "$sql_file" || {
        echo -e "${RED}Failed to execute $sql_file${NC}"
        return 1
    }
}

run_sql_query() {
    local query="$1"
    snow sql $SNOW_CONN -q "$query"
}

# Step 1: Setup Infrastructure
echo -e "\n${GREEN}[1/5] Setting up Snowflake infrastructure...${NC}"
run_sql "$CORE_DIR/snowflake/01_setup_infrastructure.sql"

# Step 2: Setup Compute Pool
echo -e "\n${GREEN}[2/5] Creating compute pool...${NC}"
run_sql "$CORE_DIR/snowflake/02_setup_compute_pool.sql"

echo -e "${YELLOW}Waiting for compute pool to be ready...${NC}"
sleep 10

# Check compute pool status
for i in {1..30}; do
    STATUS=$(run_sql_query "DESCRIBE COMPUTE POOL ${COMPUTE_POOL_NAME}" 2>/dev/null | grep -i "state" | head -1 || echo "STARTING")
    if echo "$STATUS" | grep -q -E "(ACTIVE|IDLE)"; then
        echo -e "${GREEN}Compute pool is ready!${NC}"
        break
    fi
    echo "  Waiting for compute pool... (attempt $i/30)"
    sleep 10
done

# Step 3: Setup Image Repository
echo -e "\n${GREEN}[3/5] Creating image repository...${NC}"
run_sql "$CORE_DIR/snowflake/03_setup_image_repo.sql"

# Get repository URL
echo -e "${YELLOW}Getting repository URL...${NC}"
REPO_URL=$(run_sql_query "SHOW IMAGE REPOSITORIES IN SCHEMA ${SNOWFLAKE_DATABASE}.${SNOWFLAKE_SCHEMA}" 2>/dev/null | grep -i "repository_url" | awk -F'|' '{print $3}' | tr -d ' ' | head -1)

if [ -z "$REPO_URL" ]; then
    echo -e "${YELLOW}Could not auto-detect repository URL. Please enter it manually.${NC}"
    echo "Run this SQL to get the URL: SHOW IMAGE REPOSITORIES IN SCHEMA ${SNOWFLAKE_DATABASE}.${SNOWFLAKE_SCHEMA};"
    read -p "Repository URL: " REPO_URL
fi

echo -e "${GREEN}Repository URL: $REPO_URL${NC}"

# Step 4: Build and Push Image
echo -e "\n${GREEN}[4/5] Building and pushing NiFi image...${NC}"

# Build image
echo -e "${YELLOW}Building Docker image...${NC}"
cd "$CORE_DIR/nifi"
docker build --platform linux/amd64 -t ${NIFI_IMAGE_NAME}:${NIFI_IMAGE_TAG} .

# Tag image
FULL_IMAGE="${REPO_URL}/${NIFI_IMAGE_NAME}:${NIFI_IMAGE_TAG}"
docker tag ${NIFI_IMAGE_NAME}:${NIFI_IMAGE_TAG} ${FULL_IMAGE}

# Login to registry
echo -e "${YELLOW}Logging in to Snowflake registry...${NC}"
REGISTRY_HOST=$(echo $REPO_URL | cut -d'/' -f1)

# Try snow CLI login first, fall back to docker login
snow spcs image-registry login $SNOW_CONN 2>/dev/null || {
    echo -e "${YELLOW}Using docker login...${NC}"
    snow spcs image-registry token $SNOW_CONN --format JSON 2>/dev/null | docker login $REGISTRY_HOST --username 0sessiontoken --password-stdin || {
        echo -e "${YELLOW}Please login manually:${NC}"
        docker login $REGISTRY_HOST
    }
}

# Push image
echo -e "${YELLOW}Pushing image to Snowflake...${NC}"
docker push ${FULL_IMAGE}

echo -e "${GREEN}Image pushed successfully!${NC}"

cd "$SCRIPT_DIR"

# Step 5: Setup Network Rules and Create Service
echo -e "\n${GREEN}[5/5] Setting up network rules and creating service...${NC}"

if [ "$ENABLE_EXTERNAL_ACCESS" = "true" ]; then
    run_sql "$CORE_DIR/snowflake/04_setup_network_rules.sql"
fi

run_sql "$CORE_DIR/snowflake/05_create_nifi_service.sql"

# Wait for service to be ready
echo -e "${YELLOW}Waiting for NiFi service to start...${NC}"
for i in {1..60}; do
    STATUS=$(run_sql_query "SELECT SYSTEM\$GET_SERVICE_STATUS('${SNOWFLAKE_DATABASE}.${SNOWFLAKE_SCHEMA}.${SERVICE_NAME}')" 2>/dev/null || echo "STARTING")
    if echo "$STATUS" | grep -q "READY"; then
        echo -e "${GREEN}NiFi service is ready!${NC}"
        break
    fi
    echo "  Waiting for service... (attempt $i/60)"
    sleep 10
done

# Get endpoint
echo -e "\n${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo "║                    Deployment Complete!                        ║"
echo "╚══════════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${GREEN}Getting NiFi endpoint...${NC}"
run_sql_query "SHOW ENDPOINTS IN SERVICE ${SNOWFLAKE_DATABASE}.${SNOWFLAKE_SCHEMA}.${SERVICE_NAME}"

echo -e "\n${YELLOW}NiFi Credentials:${NC}"
echo "  Username: ${NIFI_USERNAME}"
echo "  Password: ${NIFI_PASSWORD}"

echo -e "\n${YELLOW}Useful commands:${NC}"
echo "  # Check service status"
echo "  snow sql $SNOW_CONN -q \"SELECT SYSTEM\\\$GET_SERVICE_STATUS('${SERVICE_NAME}')\""
echo ""
echo "  # View logs"
echo "  snow sql $SNOW_CONN -q \"SELECT * FROM TABLE(GET_SERVICE_LOGS('${SNOWFLAKE_DATABASE}.${SNOWFLAKE_SCHEMA}.${SERVICE_NAME}', 0, 'nifi', 100))\""
echo ""
echo "  # Get endpoint"
echo "  snow sql $SNOW_CONN -q \"SHOW ENDPOINTS IN SERVICE ${SERVICE_NAME}\""
