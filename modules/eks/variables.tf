variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version. Null lets EKS pick its current default."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Private subnet IDs for the control plane ENIs and the nodes."
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Expose the API server publicly (restricted by public_access_cidrs)."
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to reach the public API endpoint. Only used when endpoint_public_access is true."
  type        = list(string)
  default     = []
}

variable "enabled_log_types" {
  description = "Control plane log types to ship to CloudWatch."
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "node_groups" {
  description = "Managed node groups keyed by name."
  type = map(object({
    instance_types = optional(list(string), ["t3.medium"])
    capacity_type  = optional(string, "ON_DEMAND")
    min_size       = optional(number, 1)
    max_size       = optional(number, 3)
    desired_size   = optional(number, 2)
    disk_size      = optional(number, 50)
    labels         = optional(map(string), {})
  }))
  default = {
    default = {}
  }
}

variable "addons" {
  description = "Core EKS add-ons to manage."
  type        = list(string)
  default     = ["vpc-cni", "coredns", "kube-proxy"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
