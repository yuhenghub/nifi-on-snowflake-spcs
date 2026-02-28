-- ============================================================================
-- 04_setup_network_rules.sql
-- Setup Network Rules for External Access
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE_PROD_USER2;
USE SCHEMA NIFI_DEMO;

-- Create network rule for external access
-- Modify VALUE_LIST based on your requirements
CREATE OR REPLACE NETWORK RULE NIFI_EGRESS_RULE
    TYPE = HOST_PORT
    MODE = EGRESS
    VALUE_LIST = (
        '0.0.0.0'  -- Allow all external access (restrict in production)
    )
    COMMENT = 'Network rule for NiFi external access';

-- Create external access integration
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION NIFI_EXTERNAL_ACCESS
    ALLOWED_NETWORK_RULES = (NIFI_EGRESS_RULE)
    ENABLED = TRUE
    COMMENT = 'External access integration for NiFi';

-- Verify
DESCRIBE EXTERNAL ACCESS INTEGRATION NIFI_EXTERNAL_ACCESS;

SELECT 'Network rules configured.' AS STATUS;
