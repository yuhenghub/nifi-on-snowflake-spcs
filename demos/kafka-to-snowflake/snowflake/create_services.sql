-- Create Kafka and Data Generator Services
USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE_PROD_USER2;
USE SCHEMA NIFI_DEMO;

-- Kafka Service
CREATE SERVICE IF NOT EXISTS KAFKA_SERVICE
    IN COMPUTE POOL NIFI_COMPUTE_POOL
    FROM SPECIFICATION $$
spec:
  containers:
    - name: kafka
      image: /snowflake_prod_user2/nifi_demo/nifi_repo/kafka-spcs:latest
      env:
        KAFKA_CFG_NODE_ID: "1"
        KAFKA_CFG_PROCESS_ROLES: "broker,controller"
        KAFKA_CFG_CONTROLLER_QUORUM_VOTERS: "1@localhost:9093"
        KAFKA_CFG_LISTENERS: "PLAINTEXT://:9092,CONTROLLER://:9093"
        KAFKA_CFG_ADVERTISED_LISTENERS: "PLAINTEXT://kafka-service:9092"
        KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP: "CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT"
        KAFKA_CFG_CONTROLLER_LISTENER_NAMES: "CONTROLLER"
        KAFKA_CFG_INTER_BROKER_LISTENER_NAME: "PLAINTEXT"
        KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE: "true"
      resources:
        requests:
          cpu: "1"
          memory: "2Gi"
        limits:
          cpu: "2"
          memory: "4Gi"
  endpoints:
    - name: kafka
      port: 9092
      protocol: TCP
$$
    MIN_INSTANCES = 1
    MAX_INSTANCES = 1;

-- Data Generator Service
CREATE SERVICE IF NOT EXISTS DATA_GENERATOR_SERVICE
    IN COMPUTE POOL NIFI_COMPUTE_POOL
    FROM SPECIFICATION $$
spec:
  containers:
    - name: generator
      image: /snowflake_prod_user2/nifi_demo/nifi_repo/data-generator:latest
      env:
        KAFKA_BOOTSTRAP: "kafka-service:9092"
        ORDERS_TOPIC: "orders_topic"
        EVENTS_TOPIC: "events_topic"
      resources:
        requests:
          cpu: "0.5"
          memory: "512Mi"
        limits:
          cpu: "1"
          memory: "1Gi"
  endpoints:
    - name: api
      port: 5000
      protocol: HTTP
      public: true
$$
    MIN_INSTANCES = 1
    MAX_INSTANCES = 1;

-- Check services
SELECT SYSTEM$GET_SERVICE_STATUS('KAFKA_SERVICE') AS KAFKA_STATUS;
SELECT SYSTEM$GET_SERVICE_STATUS('DATA_GENERATOR_SERVICE') AS GENERATOR_STATUS;
