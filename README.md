# Release Engineering - Incident.io Terraform Configuration

Manages specific Incident.io configurations for the Release Engineering
team using Terraform.

This repository currently defines and manages resources such as:
- Alert Sources (`alert_sources.tf`)
- On-call Schedules (`schedules.tf`)
  - *Note: Uses placeholder user IDs pending SCIM access.*
- Escalation Paths (`escalation_paths.tf`)
  - *Note: Contains conditional logic. The syntax for conditions
    requires verification against Incident.io provider documentation.*

## Prerequisites

- Terraform (version used during development: v1.4.6)
- An Incident.io API token with appropriate permissions, stored as the
  `INCIDENT_API_KEY` environment variable.

## Basic Usage

Standard Terraform commands are used:

1.  Initialize the Terraform provider:
    ```bash
    terraform init
    ```
2.  Generate and review an execution plan:
    ```bash
    terraform plan
    ```
3.  Apply the changes:
    ```bash
    terraform apply
    ```

## Documentation

Detailed documentation will be added as configurations are finalized
and fully tested. This will cover:
- Resource specifics and configurations
- Rationale behind conditional logic in escalation paths
- Details on required verifications (e.g., severity mapping,
  condition syntax)
- Operational procedures and best practices
