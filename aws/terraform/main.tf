module "vpc" {
  source = "./modules/vpc"

  vpc_name              = var.vpc_name
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  single_nat_gateway    = var.single_nat_gateway

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.public_subnets, module.vpc.private_subnets)

  instance_type = var.instance_type
  min_size      = var.min_size
  max_size      = var.max_size
  desired_size  = var.desired_size

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "helm_addons" {
  source = "./modules/helm"

  cluster_id = module.eks.cluster_id

  argocd_namespace              = var.argocd_namespace
  argocd_chart_version          = var.argocd_chart_version
  argo_rollouts_namespace       = var.argo_rollouts_namespace
  argo_rollouts_chart_version   = var.argo_rollouts_chart_version
  istio_namespace               = var.istio_namespace
  istio_chart_version           = var.istio_chart_version

  depends_on = [module.eks]
}
