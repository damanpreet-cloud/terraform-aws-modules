variable "name" {
  description = "Name prefix for all resources."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability zones to use, one subnet of each tier per AZ."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets, same length as azs."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets, same length as azs."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Create NAT gateways so private subnets have outbound internet access."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use one shared NAT gateway (cheaper) instead of one per AZ (more resilient)."
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Send VPC flow logs to CloudWatch Logs."
  type        = bool
  default     = false
}

variable "flow_log_retention_days" {
  description = "Retention for the flow log group."
  type        = number
  default     = 30
}

variable "eks_cluster_name" {
  description = "If set, subnets get the tags EKS load balancer discovery needs."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
