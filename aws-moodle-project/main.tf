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
  name_regex = "LabEksClusterRole"
}

data "aws_iam_role" "eks_node" {
  name_regex = "LabEksNodeRole"
}

# =====================
# EKS Module
# =====================
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.3"

  cluster_name    = "moodle-eks-cluster"
  cluster_version = "1.29"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  enable_irsa              = true
  enable_cluster_creator_admin_permissions = true

  cluster_role_arn = data.aws_iam_role.eks_cluster.arn

  eks_managed_node_group_defaults = {
    instance_types = ["t3.micro"]
    ami_type       = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    default = {
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
      subnets        = module.vpc.private_subnets
      role_arn       = data.aws_iam_role.eks_node.arn
    }
  }

  tags = {
    Environment = "moodle"
    Project     = "ITP4122"
  }
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
