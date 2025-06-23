resource "incident_workflow" "when_an_incident_is_created_or_changed_send_message_to_a_channel" {
  name    = "When an incident is created or changed: Send message to a channel"
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
            # "Alert Source: {{ alert.url }} \n\nRunbook Link: {{ incident.runbook_url }}"
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
