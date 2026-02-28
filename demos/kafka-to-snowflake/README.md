# Demo: Kafka to Snowflake

Real-time data streaming from Kafka to Snowflake via NiFi.

## Components

- **Kafka Service**: Apache Kafka running on SPCS
- **Data Generator**: Python service generating sample orders/events
- **NiFi Flow**: Consumes Kafka messages and writes to Snowflake
- **Target Tables**: Snowflake tables for orders and events

## Deploy

```bash
./deploy.sh
```

## Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Data Generator │────▶│     Kafka       │────▶│      NiFi       │
│   (orders/      │     │   (SPCS)        │     │   (SPCS)        │
│    events)      │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                         │
                                                         ▼
                                                ┌─────────────────┐
                                                │   Snowflake     │
                                                │   KAFKA_ORDERS  │
                                                │   KAFKA_EVENTS  │
                                                └─────────────────┘
```

## Data Schema

### KAFKA_ORDERS
| Column | Type | Description |
|--------|------|-------------|
| ORDER_ID | VARCHAR | Unique order ID |
| CUSTOMER_ID | VARCHAR | Customer reference |
| ORDER_DATE | TIMESTAMP | Order timestamp |
| TOTAL_AMOUNT | DECIMAL | Order total |
| STATUS | VARCHAR | Order status |
| ITEMS | VARIANT | Order items (JSON) |

### KAFKA_EVENTS
| Column | Type | Description |
|--------|------|-------------|
| EVENT_ID | VARCHAR | Unique event ID |
| EVENT_TYPE | VARCHAR | Event type |
| USER_ID | VARCHAR | User reference |
| EVENT_TIME | TIMESTAMP | Event timestamp |
| PROPERTIES | VARIANT | Event properties (JSON) |
