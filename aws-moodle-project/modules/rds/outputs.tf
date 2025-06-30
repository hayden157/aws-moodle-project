output "db_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

output "db_password" {
  value     = random_password.aurora_password.result
  sensitive = true
}
