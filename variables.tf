# GitHub secret variables

variable "incident_lead_user_id" {
  description = "The Google Workspace ID for the Release Engineering Lead."
  type        = string
  sensitive   = true
}

variable "incident_manager_user_id" {
  description = "The Google Workspace ID for the Release Engineering Manager."
  type        = string
  sensitive   = true
}

variable "incident_releng_team_id" {
  description = "The team ID for the Release Engineering team."
  type        = string
  sensitive   = true
}
