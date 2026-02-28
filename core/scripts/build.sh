#!/bin/bash
# Build NiFi Docker image for SPCS

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

echo "Building NiFi Docker image..."
echo "Image: ${NIFI_IMAGE_NAME}:${NIFI_IMAGE_TAG}"

cd "$SCRIPT_DIR/../nifi"

docker build \
    --platform linux/amd64 \
    -t ${NIFI_IMAGE_NAME}:${NIFI_IMAGE_TAG} \
    .

echo "Build complete!"
echo "Image: ${NIFI_IMAGE_NAME}:${NIFI_IMAGE_TAG}"
