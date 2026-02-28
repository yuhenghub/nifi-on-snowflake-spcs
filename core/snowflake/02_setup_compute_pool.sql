-- ============================================================================
-- 02_setup_compute_pool.sql
-- Create Compute Pool for NiFi SPCS Service
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE_PROD_USER2;
USE SCHEMA NIFI_DEMO;

-- Create compute pool
-- Instance types: CPU_X64_XS, CPU_X64_S, CPU_X64_M, CPU_X64_L
CREATE COMPUTE POOL IF NOT EXISTS NIFI_COMPUTE_POOL
    MIN_NODES = 1
    MAX_NODES = 1
    INSTANCE_FAMILY = CPU_X64_S
    AUTO_RESUME = TRUE
    AUTO_SUSPEND_SECS = 3600
    COMMENT = 'Compute pool for Apache NiFi service';

-- Check compute pool status
DESCRIBE COMPUTE POOL NIFI_COMPUTE_POOL;

SELECT 'Compute pool created. Wait for ACTIVE/IDLE status.' AS STATUS;
