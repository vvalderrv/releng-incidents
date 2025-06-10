# This defines a workflow for Release Engineering incidents.
# Workflows automate actions based on incident triggers and conditions.
resource "incident_workflow" "releng_default_workflow" {
  name = "Release Engineering Default Workflow"

  # Required arguments for the workflow's basic behavior.
  state                     = "active"
  include_private_incidents = true
  runs_on_incidents         = "newly_created"
  trigger                   = "incident.created"
  continue_on_step_error    = false
  runs_on_incident_modes    = []
  once_for                  = []
  expressions               = []
  steps                     = []

  # Filter which incidents this workflow applies to
  condition_groups = [
    {
      conditions = [
        {
          subject        = "incident.alert_source_id"
          operation      = "is_one_of"
          value          = [incident_alert_source.releng.id]
          param_bindings = []
        }
      ]
    }
  ]
}
