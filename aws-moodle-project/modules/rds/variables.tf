variable "vpc_id" {
  description = "VPC ID for RDS"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}