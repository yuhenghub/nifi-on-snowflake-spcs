-- ============================================================================
-- 05_create_nifi_service.sql
-- Create NiFi SPCS Service
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE_PROD_USER2;
USE SCHEMA NIFI_DEMO;

-- Drop existing service if needed
-- DROP SERVICE IF EXISTS NIFI_SERVICE;

-- Create NiFi service
CREATE SERVICE IF NOT EXISTS NIFI_SERVICE
    IN COMPUTE POOL NIFI_COMPUTE_POOL
    FROM SPECIFICATION $$
spec:
  containers:
    - name: nifi
      image: /snowflake_prod_user2/nifi_demo/nifi_repo/nifi-snowflake:latest
      env:
        NIFI_WEB_HTTPS_PORT: "8443"
        SINGLE_USER_CREDENTIALS_USERNAME: "admin"
        SINGLE_USER_CREDENTIALS_PASSWORD: "admin123456789"
        NIFI_SENSITIVE_PROPS_KEY: "nifi-spcs-secret-key-12345"
        TZ: "Asia/Shanghai"
      resources:
        requests:
          cpu: "2"
          memory: "4Gi"
        limits:
          cpu: "4"
          memory: "8Gi"
      readinessProbe:
        port: 8443
        path: /nifi-api/system-diagnostics
      volumeMounts:
        - name: nifi-data
          mountPath: /opt/nifi/nifi-current/data
  endpoints:
    - name: nifi-ui
      port: 8443
      protocol: HTTPS
      public: true
  volumes:
    - name: nifi-data
      source: local
      size: "10Gi"
$$
    EXTERNAL_ACCESS_INTEGRATIONS = (NIFI_EXTERNAL_ACCESS)
    MIN_INSTANCES = 1
    MAX_INSTANCES = 1
    COMMENT = 'Apache NiFi data integration service';

-- Check service status
SELECT SYSTEM$GET_SERVICE_STATUS('NIFI_SERVICE') AS SERVICE_STATUS;

-- Show endpoints (may take a few minutes)
SHOW ENDPOINTS IN SERVICE NIFI_SERVICE;

SELECT 'NiFi service created. Check SHOW ENDPOINTS for access URL.' AS STATUS;

-- ============================================================================
-- Useful Commands:
--
-- Check status:
--   SELECT SYSTEM$GET_SERVICE_STATUS('NIFI_SERVICE');
--
-- Get endpoints:
--   SHOW ENDPOINTS IN SERVICE NIFI_SERVICE;
--
-- View logs:
--   SELECT * FROM TABLE(GET_SERVICE_LOGS('SNOWFLAKE_PROD_USER2.NIFI_DEMO.NIFI_SERVICE', 0, 'nifi', 100));
--
-- Restart service:
--   ALTER SERVICE NIFI_SERVICE SUSPEND;
--   ALTER SERVICE NIFI_SERVICE RESUME;
-- ============================================================================
