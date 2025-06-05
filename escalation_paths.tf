resource "incident_escalation_path" "releng_escalation_path" {
  name = "Release Engineering Escalation Path"

  working_hours = [{ // Changed to an argument (list of objects)
    id       = "releng_business_hours"
    name     = "Release Engineering Business Hours"
    timezone = "America/Los_Angeles"
    weekday_intervals = [
      {
        weekday    = "monday"
        start_time = "09:00"
        end_time   = "17:00"
      },
      {
        weekday    = "tuesday"
        start_time = "09:00"
        end_time   = "17:00"
      },
      {
        weekday    = "wednesday"
        start_time = "09:00"
        end_time   = "17:00"
      },
      {
        weekday    = "thursday"
        start_time = "09:00"
        end_time   = "17:00"
      },
      {
        weekday    = "friday"
        start_time = "09:00"
        end_time   = "17:00"
      }
    ]
  }]

  path = [
    {
      id   = "if_business_hours"
      type = "if_else"
      if_else = {
        conditions = [
          {
            operation      = "is_active"
            subject        = "escalation.working_hours[\"releng_business_hours\"]" // Corrected subject based on doc
            param_bindings = []
          }
        ]

        then_path = [ // During Business Hours
          {
            id   = "bh_if_any_severity"
            type = "if_else"
            if_else = {
              conditions = [
                {
                  operation = "one_of"
                  subject   = "incident.severity" // Still illustrative: verify exact subject for severity
                  param_bindings = [
                    { array_value = [{ literal = "error" }, { literal = "warning" }, { literal = "info" }] }
                  ]
                }
              ]
              then_path = [ // BH & (Critical OR Major OR Minor) -> Escalate
                {
                  id   = "bh_escalate_oncall"
                  type = "level"
                  level = {
                    targets = [{
                      type    = "schedule"
                      id      = incident_schedule.releng_schedule.id
                      urgency = "high" // Added urgency
                    }]
                    time_to_ack_seconds = 1200
                  }
                },
                {
                  id   = "bh_escalate_lead"
                  type = "level"
                  level = {
                    targets = [{
                      type    = "user"
                      id      = "user:REPLACE_WITH_LEAD_USER_ID"
                      urgency = "high" // Added urgency
                    }]
                    time_to_ack_seconds = 1200
                  }
                },
                {
                  id   = "bh_escalate_manager"
                  type = "level"
                  level = {
                    targets = [{
                      type    = "user"
                      id      = "user:REPLACE_WITH_MANAGER_USER_ID"
                      urgency = "high" // Added urgency
                    }]
                    time_to_ack_seconds = 1200
                  }
                }
              ]
              else_path = [{ id = "bh_end_other_severity", type = "end" }] // BH & other severity -> End
            }
          }
        ]

        else_path = [ // After Business Hours
          {
            id   = "ooh_if_critical_severity"
            type = "if_else"
            if_else = {
              conditions = [
                {
                  operation      = "is"
                  subject        = "incident.severity" // Still illustrative: verify exact subject for severity
                  param_bindings = [{ literal = "error" }]
                }
              ]
              then_path = [ // OOH & Critical -> Escalate
                {
                  id   = "ooh_escalate_oncall"
                  type = "level"
                  level = {
                    targets = [{
                      type    = "schedule"
                      id      = incident_schedule.releng_schedule.id
                      urgency = "high" // Added urgency
                    }]
                    time_to_ack_seconds = 1200
                  }
                },
                {
                  id   = "ooh_escalate_lead"
                  type = "level"
                  level = {
                    targets = [{
                      type    = "user"
                      id      = "user:REPLACE_WITH_LEAD_USER_ID"
                      urgency = "high" // Added urgency
                    }]
                    time_to_ack_seconds = 1200
                  }
                },
                {
                  id   = "ooh_escalate_manager"
                  type = "level"
                  level = {
                    targets = [{
                      type    = "user"
                      id      = "user:REPLACE_WITH_MANAGER_USER_ID"
                      urgency = "high" // Added urgency
                    }]
                    time_to_ack_seconds = 1200
                  }
                }
              ]
              else_path = [{ id = "ooh_end_non_critical", type = "end" }] // OOH & not Critical -> End
            }
          }
        ]
      }
    }
  ]
}
