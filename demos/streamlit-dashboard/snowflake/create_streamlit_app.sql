-- Create Streamlit App
USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE_PROD_USER2;
USE SCHEMA NIFI_DEMO;
USE WAREHOUSE NIFI_DEMO_WH;

CREATE OR REPLACE STREAMLIT NIFI_DEMO_DASHBOARD
    ROOT_LOCATION = '@SNOWFLAKE_PROD_USER2.NIFI_DEMO.STREAMLIT_STAGE/app'
    MAIN_FILE = 'app.py'
    QUERY_WAREHOUSE = NIFI_DEMO_WH
    COMMENT = 'NiFi SPCS Demo Dashboard';

-- Note: You need to upload the Streamlit files to the stage
-- Or use the inline approach below

SELECT 'Streamlit app created! Upload files to stage or use Snowsight to edit.' AS STATUS;
