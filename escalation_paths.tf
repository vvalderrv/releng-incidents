resource "incident_escalation_path" "test" {
  name = "test"

  # The path defines how escalations are handled.
  # Each node in the path either sends notifications or moves to another node
  path = [
    {
      id   = "01JYEV5R7WDVBN1ANXXD11AV3H"
      type = "if_else"

      # If then conditions to determine path
      if_else = {
        conditions = [
          {
            operation      = "is_active"
            subject        = "escalation.working_hours[\"default\"]"
            param_bindings = []
          },
        ]

        # If the conditions are met:
        then_path = [
          {
            id   = "01JYEVJM046AM6C2GS40D2QJZ6"
            type = "level"

            level = {
              targets = [
                {
                  type          = "schedule"
                  id            = "01JPQQPGAG0DFKMZ9GX15C1RP5"
                  urgency       = "high"
                  schedule_mode = "currently_on_call"
                },
              ]

              # Give target(s) this long to ack before proceeding
              time_to_ack_seconds = 900
            }
          },
          {
            id   = "01JYEVMY4ZC13CQDEMV4VSN3Y0"
            type = "level"

            level = {
              targets = [
                {
                  type    = "user"
                  id      = var.incident_lead_user_id
                  urgency = "high"
                },
              ]

              # Give target(s) this long to ack before proceeding
              time_to_ack_seconds = 900
            }
          },
          {
            id   = "01JYEVNDNFWEJFE69CGNVX84BT"
            type = "level"

            level = {
              targets = [
                {
                  type    = "user"
                  id      = var.incident_manager_user_id
                  urgency = "high"
                },
              ]

              # Give target(s) this long to ack before proceeding
              time_to_ack_seconds = 900
            }
          },
        ]

        # If the conditions are *not* met:
        else_path = [
          {
            id   = "01JYEV68TZQWV1PE3N1X242P0J"
            type = "if_else"

            # If the conditions are met:
            if_else = {
              conditions = [
                {
                  subject        = "incident.severity"
                  operation      = "is"
                  value          = "critical"
                  param_bindings = []
                },
              ]

              # If the conditions are met:
              then_path = [
                {
                  id   = "01JYEV5R7WHVKK64R4NBFZQ57J"
                  type = "level"

                  level = {
                    targets = [
                      {
                        type          = "schedule"
                        id            = "01JPQQPGAG0DFKMZ9GX15C1RP5"
                        urgency       = "high"
                        schedule_mode = "currently_on_call"
                      },
                    ]

                    # Give target(s) this long to ack before proceeding
                    time_to_ack_seconds = 900
                  }
                },
                {
                  id   = "01JYEVQGDVM0KV0RFF5ERKSFBY"
                  type = "level"

                  level = {
                    targets = [
                      {
                        type    = "user"
                        id      = var.incident_lead_user_id
                        urgency = "high"
                      },
                    ]

                    # Give target(s) this long to ack before proceeding
                    time_to_ack_seconds = 900
                  }
                },
                {
                  id   = "01JYEVQXKWR3637FDK52F1EJBW"
                  type = "level"

                  level = {
                    targets = [
                      {
                        type    = "user"
                        id      = var.incident_manager_user_id
                        urgency = "high"
                      },
                    ]

                    # Give target(s) this long to ack before proceeding
                    time_to_ack_seconds = 900
                  }
                },
              ]

              # If the conditions are *not* met:
              else_path = []
            }
          },
        ]
      }
    },
  ]

  # Working hours
  working_hours = [
    {
      id       = "default"
      name     = "Working Hours"
      timezone = "America/Los_Angeles"
      weekday_intervals = [
        {
          end_time   = "17:00"
          start_time = "09:00"
          weekday    = "monday"
        },
        {
          end_time   = "17:00"
          start_time = "09:00"
          weekday    = "tuesday"
        },
        {
          end_time   = "17:00"
          start_time = "09:00"
          weekday    = "wednesday"
        },
        {
          end_time   = "17:00"
          start_time = "09:00"
          weekday    = "thursday"
        },
        {
          end_time   = "17:00"
          start_time = "09:00"
          weekday    = "friday"
        },
      ]
    },
  ]

  # Assign team IDs to an escalation path so that alerts get routed
  team_ids = [var.incident_releng_team_id]
}
