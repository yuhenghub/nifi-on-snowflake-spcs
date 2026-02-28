#!/bin/bash
# Push NiFi image to Snowflake Image Repository

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Build snow CLI connection parameter
if [ -n "$SNOWFLAKE_CONNECTION" ]; then
    SNOW_CONN="--connection $SNOWFLAKE_CONNECTION"
else
    SNOW_CONN=""
fi

echo "Getting Snowflake image repository URL..."

# Get repository URL
REPO_URL=$(snow sql $SNOW_CONN -q "SHOW IMAGE REPOSITORIES IN SCHEMA ${SNOWFLAKE_DATABASE}.${SNOWFLAKE_SCHEMA}" 2>/dev/null | grep -i "${IMAGE_REPO_NAME}" | awk -F'|' '{print $3}' | tr -d ' ' | head -1)

if [ -z "$REPO_URL" ]; then
    echo "Could not find repository URL. Please enter it manually:"
    read -p "Repository URL: " REPO_URL
fi

echo "Repository URL: $REPO_URL"

# Tag image
FULL_IMAGE="${REPO_URL}/${NIFI_IMAGE_NAME}:${NIFI_IMAGE_TAG}"
echo "Tagging image as: $FULL_IMAGE"
docker tag ${NIFI_IMAGE_NAME}:${NIFI_IMAGE_TAG} ${FULL_IMAGE}

# Login to registry
REGISTRY_HOST=$(echo $REPO_URL | cut -d'/' -f1)
echo "Logging in to $REGISTRY_HOST..."

snow spcs image-registry login $SNOW_CONN 2>/dev/null || {
    echo "Using docker login..."
    snow spcs image-registry token $SNOW_CONN --format JSON 2>/dev/null | docker login $REGISTRY_HOST --username 0sessiontoken --password-stdin || {
        echo "Please login manually:"
        docker login $REGISTRY_HOST
    }
}

# Push image
echo "Pushing image..."
docker push ${FULL_IMAGE}

echo "Push complete!"
echo "Image: $FULL_IMAGE"
