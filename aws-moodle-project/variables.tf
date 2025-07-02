variable "region" {
  default = "us-east-1"
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role to use for the EKS cluster."
  type        = string
}

variable "node_role_arn" {
  description = "The ARN of the IAM role to use for the EKS node group."
  type        = string
}
