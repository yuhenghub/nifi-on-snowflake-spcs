-- ============================================================================
-- 03_setup_image_repo.sql
-- Create Image Repository for NiFi Docker Image
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE_PROD_USER2;
USE SCHEMA NIFI_DEMO;

-- Create image repository
CREATE IMAGE REPOSITORY IF NOT EXISTS NIFI_REPO
    COMMENT = 'Repository for Apache NiFi Docker images';

-- Show repository details
SHOW IMAGE REPOSITORIES IN SCHEMA SNOWFLAKE_PROD_USER2.NIFI_DEMO;

-- Get repository URL (check the output above for repository_url column)

SELECT 'Image repository created. Use the URL above to push images.' AS STATUS;
