variable "region" {
  default = "us-east-1"
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS control plane (use the pre-existing LabEksClusterRole in Learner Lab)"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for the EKS node group (use the pre-existing LabEksNodeRole in Learner Lab)"
  type        = string
}
