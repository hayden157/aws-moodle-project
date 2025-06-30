variable "region" {
  default = "us-east-1"
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS control plane"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for the EKS node group"
  type        = string
}
