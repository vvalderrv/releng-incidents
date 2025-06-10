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

resource "incident_escalation_path" "releng_escalation_path" {
  name = "Release Engineering Escalation Path"

  path = [
    {
      id   = "if_business_hours"
      type = "if_else"
      if_else = {
        conditions = [{
          subject        = "escalation.working_hours[\"releng_business_hours\"]"
          operation      = "is_active"
          param_bindings = []
        }]
        then_path = [
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
              then_path = local.common_escalation_levels_path
              else_path = [{ id = "bh_end_other_severity", type = "end" }]
            }
          }
        ]
        else_path = [
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
              then_path = local.common_escalation_levels_path
              else_path = [{ id = "ooh_end_non_critical", type = "end" }]
            }
          }
        ]
      }
    }
  ]

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
