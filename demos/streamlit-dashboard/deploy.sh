#!/bin/bash
# Deploy Streamlit Dashboard

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
echo "║         Demo: Streamlit Dashboard                            ║"
echo "╚══════════════════════════════════════════════════════════════╝"

echo "Creating Streamlit app..."
snow sql $SNOW_CONN -f "$SCRIPT_DIR/snowflake/create_streamlit_app.sql"

echo "Dashboard deployed! Access it from Snowsight > Streamlit Apps"
