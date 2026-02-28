# Core Module - Apache NiFi on SPCS

This is the core module for deploying Apache NiFi on Snowflake Snowpark Container Services.

## Components

```
core/
├── nifi/                    # NiFi Docker image configuration
│   ├── Dockerfile           # Custom NiFi image with Snowflake driver
│   ├── conf/                # NiFi configuration files
│   └── scripts/             # Container scripts
├── snowflake/               # Snowflake SQL scripts
│   ├── 01_setup_infrastructure.sql
│   ├── 02_setup_compute_pool.sql
│   ├── 03_setup_image_repo.sql
│   ├── 04_setup_network_rules.sql
│   ├── 05_create_nifi_service.sql
│   └── 99_cleanup.sql
└── scripts/                 # Deployment scripts
    ├── config.sh            # Configuration
    ├── deploy.sh            # One-click deploy
    ├── build.sh             # Build Docker image
    ├── push.sh              # Push to Snowflake
    └── cleanup.sh           # Cleanup resources
```

## Quick Deploy

```bash
# 1. Edit configuration
vim scripts/config.sh

# 2. Run deployment
./scripts/deploy.sh
```

## Manual Deployment

If you prefer step-by-step deployment:

```bash
# 1. Setup Snowflake infrastructure
snowsql -f snowflake/01_setup_infrastructure.sql
snowsql -f snowflake/02_setup_compute_pool.sql
snowsql -f snowflake/03_setup_image_repo.sql
snowsql -f snowflake/04_setup_network_rules.sql

# 2. Build and push NiFi image
./scripts/build.sh
./scripts/push.sh

# 3. Create NiFi service
snowsql -f snowflake/05_create_nifi_service.sql
```

## Configuration

### Snowflake Settings

Edit `scripts/config.sh`:

```bash
SNOWFLAKE_DATABASE="YOUR_DATABASE"
SNOWFLAKE_SCHEMA="NIFI_DEMO"
SNOWFLAKE_WAREHOUSE="YOUR_WAREHOUSE"
SNOWFLAKE_ROLE="ACCOUNTADMIN"
```

### NiFi Settings

Edit `nifi/conf/bootstrap.conf`:

```properties
# JVM Memory
java.arg.2=-Xms1g
java.arg.3=-Xmx2g

# Timezone
java.arg.14=-Duser.timezone=Asia/Shanghai
```

## Accessing NiFi

After deployment:

```sql
-- Get service endpoint
SHOW ENDPOINTS IN SERVICE NIFI_SERVICE;

-- Check service status
SELECT SYSTEM$GET_SERVICE_STATUS('NIFI_SERVICE');

-- View logs
SELECT * FROM TABLE(GET_SERVICE_LOGS('NIFI_SERVICE', 0, 'nifi', 100));
```

Default credentials:
- Username: `admin`
- Password: `admin123456789`

## Cleanup

```bash
./scripts/cleanup.sh
```
