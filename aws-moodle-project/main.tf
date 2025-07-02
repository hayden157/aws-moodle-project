# =====================
# VPC Module
# =====================
module "vpc" {
  source = "./modules/vpc"
}

# =====================
# EKS IAM Role Auto-Detection (Learner Lab)
# =====================
variable "eks_cluster_role_name" {
  description = "The name of the pre-existing EKS Cluster IAM role."
  type        = string
}

variable "eks_node_role_name" {
  description = "The name of the pre-existing EKS Node IAM role."
  type        = string
}

data "aws_iam_role" "eks_cluster" {
  name = var.eks_cluster_role_name
}

data "aws_iam_role" "eks_node" {
  name = var.eks_node_role_name
}

# =====================
# EKS Module
# =====================
module "eks" {
  source              = "./modules/eks"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnets
  public_subnet_ids   = module.vpc.public_subnets
  iam_role_arn        = data.aws_iam_role.eks_cluster.arn
  node_role_arn       = data.aws_iam_role.eks_node.arn
}

# =====================
# RDS Module
# =====================
module "rds" {
  source              = "./modules/rds"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnets
}

# =====================
# Helm Moodle Module
# =====================
module "helm_moodle" {
  source           = "./modules/helm_moodle"
  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca       = module.eks.cluster_ca
  rds_endpoint     = module.rds.db_endpoint
  rds_password     = module.rds.db_password
}

# =====================
# EKS Data Sources (for kubectl/Helm)
# =====================
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "auth" {
  name = module.eks.cluster_name
}
