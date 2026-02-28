-- Create MySQL Service
USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE_PROD_USER2;
USE SCHEMA NIFI_DEMO;

CREATE SERVICE IF NOT EXISTS MYSQL_SERVICE
    IN COMPUTE POOL NIFI_COMPUTE_POOL
    FROM SPECIFICATION $$
spec:
  containers:
    - name: mysql
      image: /snowflake_prod_user2/nifi_demo/nifi_repo/mysql-spcs:latest
      env:
        MYSQL_ROOT_PASSWORD: "rootpassword"
        MYSQL_DATABASE: "nifi_demo"
        MYSQL_USER: "nifi_user"
        MYSQL_PASSWORD: "nifi_password"
      resources:
        requests:
          cpu: "1"
          memory: "2Gi"
        limits:
          cpu: "2"
          memory: "4Gi"
      volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
  endpoints:
    - name: mysql
      port: 3306
      protocol: TCP
  volumes:
    - name: mysql-data
      source: local
      size: "10Gi"
$$
    MIN_INSTANCES = 1
    MAX_INSTANCES = 1;

SELECT SYSTEM$GET_SERVICE_STATUS('MYSQL_SERVICE') AS STATUS;
