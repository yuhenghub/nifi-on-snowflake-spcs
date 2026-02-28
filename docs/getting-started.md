# Getting Started

This guide walks you through deploying Apache NiFi on Snowflake SPCS.

## Prerequisites

1. **Snowflake Account**
   - SPCS enabled (contact Snowflake support if needed)
   - ACCOUNTADMIN role or equivalent

2. **Local Tools**
   - Docker Desktop
   - Snowflake CLI (`snow`) - [Installation](https://docs.snowflake.com/en/developer-guide/snowflake-cli/installation)

## Step-by-Step Deployment

### 1. Clone Repository

```bash
git clone https://github.com/your-username/nifi-on-snowflake-spcs.git
cd nifi-on-snowflake-spcs
```

### 2. Configure Connection

Edit `core/scripts/config.sh`:

```bash
# Your Snowflake connection name (from ~/.snowflake/connections.toml)
SNOWFLAKE_CONNECTION="your_connection"

# Database to use
SNOWFLAKE_DATABASE="YOUR_DATABASE"

# Schema will be created
SNOWFLAKE_SCHEMA="NIFI_DEMO"
```

### 3. Deploy

```bash
cd core
chmod +x scripts/*.sh
./scripts/deploy.sh
```

### 4. Access NiFi

Get the endpoint:

```sql
SHOW ENDPOINTS IN SERVICE NIFI_SERVICE;
```

Login with:
- Username: `admin`
- Password: `admin123456789`

## Next Steps

- Configure NiFi flows for your data sources
- Deploy optional [demos](../demos/) for examples
- Read [security guide](security.md) for production hardening
