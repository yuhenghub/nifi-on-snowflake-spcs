#!/bin/bash
# Custom entrypoint for NiFi on SPCS

set -e

echo "=========================================="
echo "Starting Apache NiFi on Snowflake SPCS"
echo "=========================================="

# Print environment info
echo "NiFi Home: ${NIFI_HOME:-/opt/nifi/nifi-current}"
echo "HTTPS Port: ${NIFI_WEB_HTTPS_PORT:-8443}"
echo "Timezone: $(date +%Z)"
echo "=========================================="

# List available JDBC drivers
echo "Available JDBC Drivers:"
ls -la /opt/nifi/nifi-current/drivers/ 2>/dev/null || echo "No custom drivers found"
echo "=========================================="

# Start NiFi
exec /opt/nifi/nifi-current/bin/nifi.sh run
