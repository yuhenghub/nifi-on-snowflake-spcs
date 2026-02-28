# Troubleshooting

Common issues and solutions.

## Service Won't Start

### Check Service Status

```sql
SELECT SYSTEM$GET_SERVICE_STATUS('NIFI_SERVICE');
```

### View Logs

```sql
SELECT * FROM TABLE(GET_SERVICE_LOGS('SNOWFLAKE_PROD_USER2.NIFI_DEMO.NIFI_SERVICE', 0, 'nifi', 100));
```

### Common Issues

**Compute Pool Not Ready**
```sql
DESCRIBE COMPUTE POOL NIFI_COMPUTE_POOL;
-- Wait for state: ACTIVE or IDLE
```

**Image Not Found**
```sql
SHOW IMAGES IN IMAGE REPOSITORY NIFI_REPO;
-- Verify image was pushed successfully
```

## Network Issues

**Can't Access External Services**

Check network rules:
```sql
SHOW NETWORK RULES;
DESCRIBE EXTERNAL ACCESS INTEGRATION NIFI_EXTERNAL_ACCESS;
```

## Memory Issues

Increase resources in service spec:
```yaml
resources:
  limits:
    memory: "8Gi"
```

## Restart Service

```sql
ALTER SERVICE NIFI_SERVICE SUSPEND;
ALTER SERVICE NIFI_SERVICE RESUME;
```
