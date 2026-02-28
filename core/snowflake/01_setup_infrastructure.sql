-- ============================================================================
-- 01_setup_infrastructure.sql
-- Setup Snowflake infrastructure for NiFi on SPCS
-- ============================================================================

-- Use ACCOUNTADMIN role for setup
USE ROLE ACCOUNTADMIN;

-- Create or use database (modify database name as needed)
CREATE DATABASE IF NOT EXISTS SNOWFLAKE_PROD_USER2;
USE DATABASE SNOWFLAKE_PROD_USER2;

-- Create schema for NiFi
CREATE SCHEMA IF NOT EXISTS NIFI_DEMO
    WITH MANAGED ACCESS
    COMMENT = 'Schema for Apache NiFi on SPCS';

-- Create warehouse for operations
CREATE WAREHOUSE IF NOT EXISTS NIFI_DEMO_WH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for NiFi operations';

-- Set context
USE SCHEMA SNOWFLAKE_PROD_USER2.NIFI_DEMO;
USE WAREHOUSE NIFI_DEMO_WH;

-- Verify setup
SELECT 'Infrastructure setup complete!' AS STATUS;
