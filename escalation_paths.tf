resource "incident_escalation_path" "test" {
  name = "test"

  path = [
    {
      id   = "01JYEV5R7WDVBN1ANXXD11AV3H"
      type = "if_else"

      if_else = {
        conditions = [
          {
            operation      = "is_active"
            subject        = "escalation.working_hours[\"default\"]"
            param_bindings = []
          },
        ]

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
              time_to_ack_seconds = 900
            }
          },
        ]

        else_path = [
          {
            id   = "01JYEV68TZQWV1PE3N1X242P0J"
            type = "if_else"

            if_else = {
              conditions = [
                {
                  subject   = "escalation.priority"
                  operation = "one_of"
                  param_bindings = [
                    {
                      array_value = [
                        {
                          literal = "01JBHW8WRRZSCBB2VX1W2TB36W" # Critical priority ID
                        },
                      ]
                    },
                  ]
                },
              ]

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

  working_hours = [
    {
      id       = "default"
      name     = "Working Hours"
      timezone = "America/Los_Angeles"
      weekday_intervals = [
        {
          start_time = "09:00"
          end_time   = "17:00"
          weekday    = "monday"
        },
        {
          start_time = "09:00"
          end_time   = "17:00"
          weekday    = "tuesday"
        },
        {
          start_time = "09:00"
          end_time   = "17:00"
          weekday    = "wednesday"
        },
        {
          start_time = "09:00"
          end_time   = "17:00"
          weekday    = "thursday"
        },
        {
          start_time = "09:00"
          end_time   = "17:00"
          weekday    = "friday"
        },
      ]
    },
  ]

  team_ids = ["01JKBKXQDK07ENQAAPDJ55Q92B"]
}
