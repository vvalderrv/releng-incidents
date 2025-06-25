resource "incident_workflow" "releng_default_workflow" {
  name    = "Release Engineering Default Workflow (TF Managed)"
  trigger = "incident.updated"
  expressions = [
  ]
  condition_groups = [
    {
      conditions = [
        {
          # "Incident → Affected teams"
          subject   = "incident.custom_field[\"01JBWZPCAWQ5GTXX9VABDNJS5V\"]"
          operation = "one_of"
          param_bindings = [
            {
              array_value = [
                {
                  # "Release Engineering"
                  literal = "release-engineering"
                },
              ]
            },
          ]
        },
      ]
    },
  ]
  steps = [
    {
      # "Send message to a channel"
      id   = "01JYF1S38KV9KDBFYRFMGHZTAF"
      name = "slack.post_message"
      param_bindings = [
        # "Channel"
        {
          value = {
            # "Incident → Slack Channel"
            reference = "incident.slack_channel"
          }
        },
        # "Message"
        {
          value = {
            literal = "{\"content\":[{\"content\":[{\"marks\":[{\"type\":\"code\"}],\"text\":\"Alert Source: {{ alert.url }}\",\"type\":\"text\"},{\"text\":\" \",\"type\":\"text\"}],\"type\":\"paragraph\"},{\"content\":[{\"marks\":[{\"type\":\"code\"}],\"text\":\"Runbook Link: {{ incident.runbook_url }}\",\"type\":\"text\"}],\"type\":\"paragraph\"}],\"type\":\"doc\"}"
          }
        },
        # "Threaded Message"
        {
        },
        # "Timezone"
        {
          value = {
            # "America/Los Angeles"
            literal = "America/Los_Angeles"
          }
        },
      ]
    },
  ]
  once_for = [
    # "Incident"
    "incident",
  ]
  include_private_incidents = false
  continue_on_step_error    = false
  runs_on_incidents         = "newly_created"
  runs_on_incident_modes = [
    "standard",
  ]
  state = "active"
}
