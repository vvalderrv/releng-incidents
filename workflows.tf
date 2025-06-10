# workflows.tf
# Adding the param_bindings attribute to the trigger condition.

resource "incident_workflow" "releng_default_workflow" {
  name = "Release Engineering Default Workflow"

  # Required arguments with default values.
  state                     = "active"
  include_private_incidents = true
  runs_on_incidents         = true
  trigger                   = "incident.created"
  continue_on_step_error    = false
  runs_on_incident_modes    = []
  once_for                  = []
  expressions               = []
  steps                     = []

  # This block now contains the logic to filter for our specific alert source.
  condition_groups = [
    {
      conditions = [
        {
          subject        = "incident.alert_source_id"
          operation      = "is_one_of"
          value          = [incident_alert_source.releng.id]
          param_bindings = [] # Adding the required empty attribute
        }
      ]
    }
  ]
}
