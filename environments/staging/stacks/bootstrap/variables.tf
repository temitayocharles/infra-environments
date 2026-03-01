variable "argocd_repo_passwords" {
  description = "Sensitive repository password/token map keyed by repository name for Argo CD bootstrap secrets."
  type        = map(string)
  default     = {}
  sensitive   = true
}
