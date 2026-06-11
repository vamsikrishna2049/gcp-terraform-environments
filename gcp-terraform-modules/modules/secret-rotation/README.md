# Secret Rotation Module

This Terraform module creates a Cloud Run service for secret rotation, a scheduler job to trigger rotation, and an Eventarc trigger for the Cloud Run service.

## Resources

- `google_service_account.rotation_sa`
- `google_cloud_run_v2_service.rotation_svc`
- `google_pubsub_topic.rotation_topic`
- `google_eventarc_trigger.rotation_trig`
- `google_cloud_scheduler_job.rotation_job`

## Inputs

- `project_id`
- `region`
- `environment`
- `rotation_service_image`
- `cloud_sql_instance_name`
- `secret_id`
- `rotation_schedule`

## Outputs

- `rotation_service_account`
- `rotation_service_url`
- `rotation_job_id`
