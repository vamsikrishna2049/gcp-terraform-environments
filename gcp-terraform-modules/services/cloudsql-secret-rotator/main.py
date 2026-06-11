import os
import logging
from google.cloud import secretmanager

logging.basicConfig(level=logging.INFO)

PROJECT_ID = os.getenv("PROJECT_ID")
SECRET_ID = os.getenv("SECRET_ID")
CLOUD_SQL_INSTANCE = os.getenv("CLOUD_SQL_INSTANCE")

if not PROJECT_ID or not SECRET_ID or not CLOUD_SQL_INSTANCE:
    raise SystemExit("PROJECT_ID, SECRET_ID, and CLOUD_SQL_INSTANCE must be provided")

client = secretmanager.SecretManagerServiceClient()
secret_name = f"projects/{PROJECT_ID}/secrets/{SECRET_ID}/versions/latest"


def rotate_secret():
    response = client.access_secret_version(name=secret_name)
    payload = response.payload.data.decode("UTF-8")
    logging.info("Secret rotation triggered for instance %s", CLOUD_SQL_INSTANCE)
    logging.info("Secret value length: %d", len(payload))
    # Placeholder for rotation logic
    return payload


if __name__ == "__main__":
    rotate_secret()
