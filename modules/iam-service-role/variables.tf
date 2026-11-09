variable "name" {
  description = "Role name."
  type        = string
}

variable "trusted_services" {
  description = "AWS service principals allowed to assume the role, e.g. [\"lambda.amazonaws.com\"]."
  type        = list(string)

  validation {
    condition     = length(var.trusted_services) > 0
    error_message = "Provide at least one trusted service principal."
  }
}

variable "policy_arns" {
  description = "Managed policy ARNs to attach."
  type        = list(string)
  default     = []
}

variable "inline_policy_json" {
  description = "Optional inline policy document (JSON)."
  type        = string
  default     = null
}

variable "permissions_boundary_arn" {
  description = "Optional permissions boundary."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds."
  type        = number
  default     = 3600
}

variable "tags" {
  type    = map(string)
  default = {}
}
