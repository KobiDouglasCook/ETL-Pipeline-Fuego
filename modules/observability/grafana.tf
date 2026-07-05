# Create Managed Grafana Workspace
resource "aws_grafana_workspace" "this" {
  name                     = var.grafana_workspace_name
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  role_arn                 = var.grafana_role_arn

  data_sources = [
    "CLOUDWATCH"
  ]
}


