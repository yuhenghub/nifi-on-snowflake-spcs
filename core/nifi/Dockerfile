# Apache NiFi Docker Image for Snowflake SPCS
# Includes Snowflake JDBC driver and common database connectors

FROM apache/nifi:2.0.0

USER root

# Install additional tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    netcat-openbsd \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Create directories for additional drivers
RUN mkdir -p /opt/nifi/nifi-current/drivers

# Download Snowflake JDBC Driver
ARG SNOWFLAKE_JDBC_VERSION=3.14.4
RUN wget -q https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/${SNOWFLAKE_JDBC_VERSION}/snowflake-jdbc-${SNOWFLAKE_JDBC_VERSION}.jar \
    -O /opt/nifi/nifi-current/drivers/snowflake-jdbc-${SNOWFLAKE_JDBC_VERSION}.jar

# Download MySQL Connector/J
ARG MYSQL_CONNECTOR_VERSION=8.0.33
RUN wget -q https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/${MYSQL_CONNECTOR_VERSION}/mysql-connector-j-${MYSQL_CONNECTOR_VERSION}.jar \
    -O /opt/nifi/nifi-current/drivers/mysql-connector-j-${MYSQL_CONNECTOR_VERSION}.jar

# Download PostgreSQL JDBC Driver
ARG POSTGRES_JDBC_VERSION=42.6.0
RUN wget -q https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_JDBC_VERSION}/postgresql-${POSTGRES_JDBC_VERSION}.jar \
    -O /opt/nifi/nifi-current/drivers/postgresql-${POSTGRES_JDBC_VERSION}.jar

# Set proper permissions
RUN chown -R nifi:nifi /opt/nifi/nifi-current/drivers

# Copy custom configuration
COPY conf/bootstrap.conf /opt/nifi/nifi-current/conf/bootstrap.conf
COPY scripts/entrypoint.sh /opt/nifi/scripts/entrypoint.sh

RUN chmod +x /opt/nifi/scripts/entrypoint.sh && \
    chown nifi:nifi /opt/nifi/scripts/entrypoint.sh

# Set environment variables for SPCS
ENV NIFI_WEB_HTTPS_PORT=8443
ENV NIFI_WEB_HTTP_PORT=""
ENV SINGLE_USER_CREDENTIALS_USERNAME=admin
ENV SINGLE_USER_CREDENTIALS_PASSWORD=admin123456789
ENV NIFI_SENSITIVE_PROPS_KEY=nifi-spcs-secret-key-12345

# Switch back to nifi user
USER nifi

# Expose HTTPS port
EXPOSE 8443

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=5 \
    CMD curl -k -f https://localhost:8443/nifi-api/system-diagnostics || exit 1

# Use custom entrypoint
ENTRYPOINT ["/opt/nifi/scripts/entrypoint.sh"]
