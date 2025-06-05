resource "incident_alert_source" "releng" {
  name        = "LF Releng Alerts"
  source_type = "datadog"

  template = {
    title = {
      literal = jsonencode({
        type = "doc"
        content = [
          {
            type = "paragraph"
            content = [
              {
                type = "text"
                text = "LF Releng Alerts"
              }
            ]
          }
        ]
      })
    }
    description = {
      literal = jsonencode({
        type = "doc"
        content = [
          {
            type = "paragraph"
            content = [
              {
                type = "text"
                text = "Datadog alerts for Release Engineering"
              }
            ]
          }
        ]
      })
    }
    expressions = []
    attributes  = []
  }
}
