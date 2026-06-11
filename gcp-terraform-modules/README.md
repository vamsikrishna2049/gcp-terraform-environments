# GCP Terraform Modules

Reusable Terraform modules for GCP infrastructure including networking, VMs, Cloud SQL, secret management, secret rotation, Cloud Run, and load balancing.

## Structure

- `modules/network`
- `modules/compute-vm`
- `modules/cloud-sql-postgres`
- `modules/secret-manager`
- `modules/secret-rotation`
- `modules/cloud-run`
- `modules/load-balancer`
- `modules/vm-cloudsql-stack`
- `bootstrap`
- `services/cloudsql-secret-rotator`
- `tests/network_test`

## Usage

Each module provides a `README.md` with inputs, outputs, and resource details. Use the `bootstrap/bootstrap.sh` script to set up initial state buckets and service accounts.
