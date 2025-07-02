# =====================
# VPC Module
# =====================
module "vpc" {
  source = "./modules/vpc"
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
  # You will need to manually provide these values after EKS cluster is created
  cluster_name     = "<your-eks-cluster-name>"
  cluster_endpoint = "<your-eks-cluster-endpoint>"
  cluster_ca       = "<your-eks-cluster-ca-data>"
  rds_endpoint     = module.rds.db_endpoint
  rds_password     = module.rds.db_password
}
