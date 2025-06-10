locals {
  releng_start_time = "09:00"
  releng_end_time   = "17:00"
  weekdays          = ["monday", "tuesday", "wednesday", "thursday", "friday"]

  escalation_targets = {
    oncall  = "user:REPLACE_WITH_ONCALL_USER_ID"
    lead    = "user:REPLACE_WITH_LEAD_USER_ID"
    manager = "user:REPLACE_WITH_MANAGER_USER_ID"
  }

  common_escalation_levels_path = [
    for name, uid in local.escalation_targets : {
      id   = "escalate_${name}"
      type = "level"
      level = {
        targets = [{
          id      = uid
          type    = "user"
          urgency = "high"
        }]
        time_to_ack_seconds = 1200
      }
    }
  ]

  bh_severities = ["error", "info", "warning"]
  ooh_severity  = "error"
}

# This defines an escalation path for Release Engineering incidents.
# It sets up how alerts will escalate through different people based on
# whether it's during business hours or not, and the incident's severity.
resource "incident_escalation_path" "releng_escalation_path" {
  name = "Release Engineering Escalation Path"

  # Assign this escalation path to specific Incident.io Teams.
  # An empty list means it's not restricted to specific teams,
  # allowing it to be used more broadly or assigned manually later.
  team_ids = []

  # This is the sequence of steps the escalation will follow.
  path = [
    # This is the main decision point: are we currently in business hours?
    {
      id   = "if_business_hours"
      type = "if_else"
      if_else = {
        conditions = [
          # Check if our defined business hours are active right now.
          {
            subject        = "escalation.working_hours[\"releng_business_hours\"]"
            operation      = "is_active"
            param_bindings = []
          },
        ]
        # If it's NOT business hours, follow this path.
        else_path = [
          # Outside business hours, we only escalate for critical incidents.
          {
            id   = "ooh_critical_check"
            type = "if_else"
            if_else = {
              conditions = [{
                subject        = "incident.severity"
                operation      = "is"
                value          = local.ooh_severity
                param_bindings = []
              }]
              # If it's NOT a critical incident outside business hours, stop the escalation.
              else_path = []
              # If it IS a critical incident outside business hours, follow the common escalation path.
              then_path = local.common_escalation_levels_path
            }
          },
        ]
        # If it IS business hours, follow this path.
        then_path = [
          # During business hours, we escalate for Critical, Major, and Minor severities.
          {
            id   = "bh_severity_check"
            type = "if_else"
            if_else = {
              conditions = [{
                subject        = "incident.severity"
                operation      = "one_of"
                value          = local.bh_severities
                param_bindings = []
              }]
              # If the severity is not one of those during business hours, stop.
              else_path = []
              # If it IS one of those severities during business hours, follow the common escalation path.
              then_path = local.common_escalation_levels_path
            }
          },
        ]
      }
    }
  ]

  # This block defines what our "business hours" are for the escalation logic.
  working_hours = [{
    id       = "releng_business_hours"
    name     = "Release Engineering Business Hours"
    timezone = "America/Los_Angeles"
    weekday_intervals = [
      for day in local.weekdays : {
        weekday    = day
        start_time = local.releng_start_time
        end_time   = local.releng_end_time
      }
    ]
  }]
}
