# Create escalation path
resource "incident_escalation_path" "releng" {
  name = "Release Engineering (TF Managed)"

  working_hours = [
    {
      id       = "default"
      name     = "Working Hours"
      timezone = "America/Los_Angeles"
      weekday_intervals = [
        { weekday = "monday", start_time = "09:00", end_time = "17:00" },
        { weekday = "tuesday", start_time = "09:00", end_time = "17:00" },
        { weekday = "wednesday", start_time = "09:00", end_time = "17:00" },
        { weekday = "thursday", start_time = "09:00", end_time = "17:00" },
        { weekday = "friday", start_time = "09:00", end_time = "17:00" },
      ]
    },
  ]

  path = [
    {
      id   = "check_working_hours"
      type = "if_else"

      if_else = {
        conditions = [
          {
            subject        = "escalation.working_hours[\"default\"]"
            operation      = "is_active"
            param_bindings = []
          },
        ]

        then_path = [
          {
            id   = "working_oncall"
            type = "level"
            level = {
              targets = [
                {
                  type          = "schedule"
                  id            = "01JPQQPGAG0DFKMZ9GX15C1RP5"
                  schedule_mode = "currently_on_call"
                  urgency       = "high"
                },
              ]
              time_to_ack_seconds = 900
            }
          },
          {
            id   = "working_lead"
            type = "level"
            level = {
              targets = [
                {
                  type    = "user"
                  id      = var.incident_lead_user_id
                  urgency = "high"
                },
              ]
              time_to_ack_seconds = 900
            }
          },
          {
            id   = "working_manager"
            type = "level"
            level = {
              targets = [
                {
                  type    = "user"
                  id      = var.incident_manager_user_id
                  urgency = "high"
                },
              ]
              time_to_ack_seconds = 900
            }
          },
        ]

        else_path = [
          {
            id   = "check_priority"
            type = "if_else"

            if_else = {
              conditions = [
                {
                  subject   = "incident.priority"
                  operation = "is"
                  param_bindings = [
                    {
                      value = {
                        literal = "P1"
                      }
                    },
                  ]
                },
              ]

              then_path = [
                {
                  id   = "offhours_oncall"
                  type = "level"
                  level = {
                    targets = [
                      {
                        type          = "schedule"
                        id            = "01JPQQPGAG0DFKMZ9GX15C1RP5"
                        schedule_mode = "currently_on_call"
                        urgency       = "high"
                      },
                    ]
                    time_to_ack_seconds = 900
                  }
                },
                {
                  id   = "offhours_lead"
                  type = "level"
                  level = {
                    targets = [
                      {
                        type    = "user"
                        id      = var.incident_lead_user_id
                        urgency = "high"
                      },
                    ]
                    time_to_ack_seconds = 900
                  }
                },
                {
                  id   = "offhours_manager"
                  type = "level"
                  level = {
                    targets = [
                      {
                        type    = "user"
                        id      = var.incident_manager_user_id
                        urgency = "high"
                      },
                    ]
                    time_to_ack_seconds = 900
                  }
                },
              ]

              else_path = []
            }
          },
        ]
      }
    },
  ]

  team_ids = [var.incident_releng_team_id]
}
