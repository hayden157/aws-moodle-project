module "vpc" {
  source = "./modules/vpc"
}

# Auto-detect EKS IAM roles by name pattern (for Learner Lab environments)
data "aws_iam_role" "eks_cluster" {
  name_regex = "LabEksClusterRole"
}

data "aws_iam_role" "eks_node" {
  name_regex = "LabEksNodeRole"
}

module "eks" {
  source              = "./modules/eks"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnets
  public_subnet_ids   = module.vpc.public_subnets
  cluster_role_arn    = data.aws_iam_role.eks_cluster.arn
  node_role_arn       = data.aws_iam_role.eks_node.arn
}

module "rds" {
  source              = "./modules/rds"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnets
}

module "helm_moodle" {
  source           = "./modules/helm_moodle"
  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca       = module.eks.cluster_ca
  rds_endpoint     = module.rds.db_endpoint
  rds_password     = module.rds.db_password
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "auth" {
  name = module.eks.cluster_name
}
