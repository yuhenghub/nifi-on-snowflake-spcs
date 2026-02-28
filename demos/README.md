# Demo Modules

Optional demo modules showcasing NiFi on SPCS capabilities.

## Available Demos

| Demo | Description | Prerequisites |
|------|-------------|---------------|
| [kafka-to-snowflake](kafka-to-snowflake/) | Real-time Kafka streaming to Snowflake | Core module deployed |
| [mysql-to-snowflake](mysql-to-snowflake/) | MySQL CDC/sync to Snowflake | Core module deployed |
| [streamlit-dashboard](streamlit-dashboard/) | Visual control panel | Core + at least one data demo |

## Quick Deploy

```bash
# Deploy all demos
./deploy-all.sh

# Or deploy individually
cd kafka-to-snowflake && ./deploy.sh
cd mysql-to-snowflake && ./deploy.sh
cd streamlit-dashboard && ./deploy.sh
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Snowflake SPCS                                │
│                                                                  │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │   Kafka     │───▶│             │    │   MySQL     │         │
│  │  Service    │    │    NiFi     │◀───│  Service    │         │
│  └─────────────┘    │   Service   │    └─────────────┘         │
│                     │             │                             │
│  ┌─────────────┐    └──────┬──────┘                            │
│  │ Data Gen    │           │                                    │
│  │  Service    │───────────┘                                    │
│  └─────────────┘           │                                    │
│                            ▼                                    │
│                   ┌─────────────┐                               │
│                   │  Snowflake  │                               │
│                   │   Tables    │                               │
│                   └─────────────┘                               │
│                            │                                    │
│                            ▼                                    │
│                   ┌─────────────┐                               │
│                   │  Streamlit  │                               │
│                   │  Dashboard  │                               │
│                   └─────────────┘                               │
└─────────────────────────────────────────────────────────────────┘
```
