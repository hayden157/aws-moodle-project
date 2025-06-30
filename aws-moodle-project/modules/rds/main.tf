resource "random_password" "aurora_password" {
  length  = 16
  special = false
}

resource "aws_db_subnet_group" "default" {
  name       = "moodle-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "moodle-db-subnet-group"
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "moodle-aurora-cluster"
  engine                 = "aurora-mysql"
  engine_mode            = "provisioned"
  master_username        = "root"
  master_password        = random_password.aurora_password.result
  database_name          = "moodledb"
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = 1
  identifier         = "moodle-aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.aurora.engine
  publicly_accessible = false
}

resource "aws_security_group" "rds" {
  name   = "moodle-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # allow internal access from EKS nodes
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "moodle-rds-sg"
  }
}
