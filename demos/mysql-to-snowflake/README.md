# Demo: MySQL to Snowflake

Database synchronization from MySQL to Snowflake via NiFi.

## Components

- **MySQL Service**: MySQL 8.0 running on SPCS
- **Sample Data**: Customers and products tables
- **NiFi Flow**: Queries MySQL and writes to Snowflake
- **Target Tables**: Snowflake tables mirroring MySQL

## Deploy

```bash
./deploy.sh
```

## Data Schema

### MYSQL_CUSTOMERS
| Column | Type | Description |
|--------|------|-------------|
| ID | INT | Primary key |
| CUSTOMER_ID | VARCHAR | Customer code |
| FIRST_NAME | VARCHAR | First name |
| LAST_NAME | VARCHAR | Last name |
| EMAIL | VARCHAR | Email address |
| CITY | VARCHAR | City |
| UPDATED_AT | TIMESTAMP | Last update |

### MYSQL_PRODUCTS
| Column | Type | Description |
|--------|------|-------------|
| ID | INT | Primary key |
| PRODUCT_ID | VARCHAR | Product code |
| PRODUCT_NAME | VARCHAR | Product name |
| CATEGORY | VARCHAR | Category |
| PRICE | DECIMAL | Price |
| STOCK | INT | Stock quantity |
