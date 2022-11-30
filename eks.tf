module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "Karlen-eks-cluster"
  cluster_version = "1.24"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size = 50
    #instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    general = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      labels = {
        role = "general"
      }
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }

    spot = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      labels = {
        role = "spot"
      }

      taints = [{
        key    = "market"
        value  = "spot"
        effect = "NO_SCHEDULE"
      }]

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "dev"

  }
}