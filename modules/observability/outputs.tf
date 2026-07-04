output "grafana_workspace_id" {
  value       = aws_grafana_workspace.this.id
  description = "The ID of the Grafana workspace"
}

output "grafana_workspace_endpoint" {
  value       = aws_grafana_workspace.this.endpoint
  description = "The endpoint URL of the Grafana workspace"
}
