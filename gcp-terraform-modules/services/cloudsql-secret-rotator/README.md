# Cloud SQL Secret Rotator

This Python service is intended for rotating Cloud SQL-related secrets via Cloud Run.

## Environment Variables

- `PROJECT_ID`
- `SECRET_ID`
- `CLOUD_SQL_INSTANCE`

## Build

```bash
docker build -t rotator:latest .
```
