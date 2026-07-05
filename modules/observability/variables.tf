variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "grafana_role_arn" {
  description = "ARN of the IAM role for Grafana"
  type        = string
}

variable "grafana_workspace_name" {
  description = "Name of the Grafana workspace"
  type        = string
  default     = "etl-grafana-workspace"
}
