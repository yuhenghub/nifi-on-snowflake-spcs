-- ============================================================================
-- 99_cleanup.sql
-- Cleanup all NiFi SPCS resources
-- WARNING: This will delete all resources!
-- ============================================================================

USE ROLE ACCOUNTADMIN;

-- Step 1: Suspend and drop service
ALTER SERVICE IF EXISTS SNOWFLAKE_PROD_USER2.NIFI_DEMO.NIFI_SERVICE SUSPEND;
DROP SERVICE IF EXISTS SNOWFLAKE_PROD_USER2.NIFI_DEMO.NIFI_SERVICE;

-- Step 2: Drop compute pool
DROP COMPUTE POOL IF EXISTS NIFI_COMPUTE_POOL;

-- Step 3: Drop external access integration
DROP EXTERNAL ACCESS INTEGRATION IF EXISTS NIFI_EXTERNAL_ACCESS;

-- Step 4: Drop network rules and image repository
USE DATABASE SNOWFLAKE_PROD_USER2;
USE SCHEMA NIFI_DEMO;

DROP NETWORK RULE IF EXISTS NIFI_EGRESS_RULE;
DROP IMAGE REPOSITORY IF EXISTS NIFI_REPO;

-- Step 5: Optional - Drop schema (uncomment if needed)
-- DROP SCHEMA IF EXISTS SNOWFLAKE_PROD_USER2.NIFI_DEMO CASCADE;

-- Step 6: Optional - Drop warehouse (uncomment if needed)
-- DROP WAREHOUSE IF EXISTS NIFI_DEMO_WH;

SELECT 'Cleanup complete!' AS STATUS;
