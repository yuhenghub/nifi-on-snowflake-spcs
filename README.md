# Apache NiFi on Snowflake SPCS

🚀 Deploy Apache NiFi on Snowflake Snowpark Container Services (SPCS)

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Snowflake](https://img.shields.io/badge/Snowflake-SPCS-29B5E8)](https://www.snowflake.com/)
[![NiFi](https://img.shields.io/badge/Apache%20NiFi-2.0+-728E9B)](https://nifi.apache.org/)

## Overview

This repository provides everything you need to deploy **Apache NiFi** on **Snowflake Snowpark Container Services (SPCS)**. It includes:

- 🔷 **Core Module**: Production-ready NiFi deployment on SPCS
- 🔶 **Demo Modules**: Optional demos showcasing Kafka/MySQL to Snowflake data pipelines

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    Snowflake Cloud                                   │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │              Snowpark Container Services (SPCS)                 │ │
│  │                                                                 │ │
│  │  ┌─────────────────────────────────────────────────────────┐   │ │
│  │  │                  Apache NiFi Service                     │   │ │
│  │  │                                                          │   │ │
│  │  │   • Data ingestion from various sources                  │   │ │
│  │  │   • ETL/ELT processing                                   │   │ │
│  │  │   • Real-time data streaming                             │   │ │
│  │  │   • Direct integration with Snowflake                    │   │ │
│  │  │                                                          │   │ │
│  │  │   Endpoint: https://<service-url>:8443                   │   │ │
│  │  └─────────────────────────────────────────────────────────┘   │ │
│  │                                                                 │ │
│  │  Compute Pool: NIFI_COMPUTE_POOL                               │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

## Quick Start

### Prerequisites

- Snowflake account with SPCS enabled
- Docker installed locally (for building images)
- Snowflake CLI (`snow`) installed - [Installation Guide](https://docs.snowflake.com/en/developer-guide/snowflake-cli/installation/installation)

### Deploy NiFi (5 minutes)

```bash
# 1. Clone the repository
git clone https://github.com/yuhenghub/nifi-on-snowflake-spcs.git
cd nifi-on-snowflake-spcs

# 2. Configure your Snowflake connection
# Edit core/scripts/config.sh with your Snowflake details
vim core/scripts/config.sh

# 3. One-click deploy
cd core
chmod +x scripts/*.sh
./scripts/deploy.sh
```

### Access NiFi UI

After deployment, get the NiFi endpoint:

```sql
SHOW ENDPOINTS IN SERVICE NIFI_SERVICE;
```

Default credentials:
- **Username**: `admin`
- **Password**: `admin123456789`

## 📦 Project Structure

```
nifi-on-snowflake-spcs/
├── core/                           # 🔷 Core Module (Required)
│   ├── nifi/                       #    NiFi Docker image
│   │   ├── Dockerfile              #    Custom NiFi image
│   │   ├── conf/                   #    Configuration files
│   │   └── scripts/                #    Container scripts
│   ├── snowflake/                  #    Snowflake SQL scripts
│   │   ├── 01_setup_infrastructure.sql
│   │   ├── 02_setup_compute_pool.sql
│   │   ├── 03_setup_image_repo.sql
│   │   ├── 04_setup_network_rules.sql
│   │   ├── 05_create_nifi_service.sql
│   │   └── 99_cleanup.sql
│   └── scripts/                    #    Deployment scripts
│       ├── config.sh               #    Configuration
│       ├── deploy.sh               #    One-click deploy
│       └── cleanup.sh              #    Cleanup resources
│
├── demos/                          # 🔶 Demo Modules (Optional)
│   ├── kafka-to-snowflake/         #    Kafka streaming demo
│   ├── mysql-to-snowflake/         #    MySQL sync demo
│   └── streamlit-dashboard/        #    Visual control panel
│
└── docs/                           # Documentation
```

## Modules

| Module | Description | Required |
|--------|-------------|----------|
| `core/` | NiFi on SPCS deployment | ✅ Yes |
| `demos/kafka-to-snowflake/` | Real-time Kafka to Snowflake | Optional |
| `demos/mysql-to-snowflake/` | MySQL CDC to Snowflake | Optional |
| `demos/streamlit-dashboard/` | Visual monitoring dashboard | Optional |

## Configuration

### Snowflake Settings

Edit `core/scripts/config.sh`:

```bash
# Snowflake CLI connection name
SNOWFLAKE_CONNECTION="your_connection"

# Database name
SNOWFLAKE_DATABASE="SNOWFLAKE_PROD_USER2"

# Schema name
SNOWFLAKE_SCHEMA="NIFI_DEMO"
```

### NiFi Settings

Edit `core/nifi/conf/bootstrap.conf`:

```properties
# JVM Memory
java.arg.2=-Xms1g
java.arg.3=-Xmx2g

# Timezone
java.arg.14=-Duser.timezone=Asia/Shanghai
```

### Network Access

To allow NiFi to access external services, update `core/snowflake/04_setup_network_rules.sql`:

```sql
CREATE OR REPLACE NETWORK RULE NIFI_EGRESS_RULE
    TYPE = HOST_PORT
    MODE = EGRESS
    VALUE_LIST = (
        'your-kafka-host:9092',
        'your-mysql-host:3306'
    );
```

## Deploy Demo Modules (Optional)

```bash
# Deploy Kafka demo
cd demos/kafka-to-snowflake && ./deploy.sh

# Deploy MySQL demo
cd demos/mysql-to-snowflake && ./deploy.sh

# Deploy Streamlit dashboard
cd demos/streamlit-dashboard && ./deploy.sh
```

## Useful Commands

```sql
-- Check service status
SELECT SYSTEM$GET_SERVICE_STATUS('NIFI_SERVICE');

-- Get service endpoint
SHOW ENDPOINTS IN SERVICE NIFI_SERVICE;

-- View service logs
SELECT * FROM TABLE(GET_SERVICE_LOGS('SNOWFLAKE_PROD_USER2.NIFI_DEMO.NIFI_SERVICE', 0, 'nifi', 100));

-- Restart service
ALTER SERVICE NIFI_SERVICE SUSPEND;
ALTER SERVICE NIFI_SERVICE RESUME;
```

## Cleanup

```bash
# Remove all resources
cd core && ./scripts/cleanup.sh

# Or run SQL directly
snow sql -f core/snowflake/99_cleanup.sql
```

## Documentation

- [Getting Started Guide](docs/getting-started.md)
- [Troubleshooting](docs/troubleshooting.md)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](docs/)
- 🐛 [Report Issues](https://github.com/yuhenghub/nifi-on-snowflake-spcs/issues)
