#!/bin/bash
# Configuration for NiFi on SPCS deployment
# Edit these values according to your environment

# ============================================================================
# Snowflake Connection Settings
# ============================================================================

# Snowflake CLI connection name (from ~/.snowflake/connections.toml)
# Leave empty to use default connection
SNOWFLAKE_CONNECTION="china_dev"

# Snowflake account (optional if using connection name)
# SNOWFLAKE_ACCOUNT="your_account.cn-northwest-1.aws"

# ============================================================================
# Database Settings
# ============================================================================

# Database name
SNOWFLAKE_DATABASE="SNOWFLAKE_PROD_USER2"

# Schema name (will be created if not exists)
SNOWFLAKE_SCHEMA="NIFI_DEMO"

# Warehouse name (will be created if not exists)
SNOWFLAKE_WAREHOUSE="NIFI_DEMO_WH"

# Role to use
SNOWFLAKE_ROLE="ACCOUNTADMIN"

# ============================================================================
# SPCS Settings
# ============================================================================

# Compute pool name
COMPUTE_POOL_NAME="NIFI_COMPUTE_POOL"

# Compute pool instance type
# Options: CPU_X64_XS, CPU_X64_S, CPU_X64_M, CPU_X64_L
COMPUTE_POOL_INSTANCE="CPU_X64_S"

# Compute pool nodes
COMPUTE_POOL_MIN_NODES=1
COMPUTE_POOL_MAX_NODES=1

# Image repository name
IMAGE_REPO_NAME="NIFI_REPO"

# Service name
SERVICE_NAME="NIFI_SERVICE"

# ============================================================================
# NiFi Settings
# ============================================================================

# NiFi image name
NIFI_IMAGE_NAME="nifi-snowflake"
NIFI_IMAGE_TAG="latest"

# NiFi credentials
NIFI_USERNAME="admin"
NIFI_PASSWORD="admin123456789"

# ============================================================================
# Network Settings (for external access)
# ============================================================================

# Enable external access (true/false)
ENABLE_EXTERNAL_ACCESS="true"

# Allowed external hosts (comma-separated)
# Example: "api.example.com:443,kafka.example.com:9092"
ALLOWED_EXTERNAL_HOSTS="0.0.0.0"
