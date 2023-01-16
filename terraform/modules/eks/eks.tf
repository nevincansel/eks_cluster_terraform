module "eks" {
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "18.26.0"
  cluster_name              = var.cluster_name
  cluster_version           = "1.22"
  subnet_ids                = var.subnet_ids
  vpc_id                    = var.vpc_id

  eks_managed_node_group_defaults = {
    disk_size      = 50
    min_size       = var.desired_nodes
    max_size       = 10
    desired_size   = var.desired_nodes
    capacity_type  = "SPOT"
  }

  eks_managed_node_groups = {
    "eks_cluster" = {
      instance_types = [var.instance_type_nodes]
      desired_capacity   = var.desired_nodes
    }    
  }

  aws_auth_users = [
    {
      userarn  = var.eks_userarn
      username = var.eks_username
      groups   : [
        "system:nodes", "system:masters"
      ]
    }
  ]

  cluster_enabled_log_types = [
    "api","audit","authenticator","controllerManager","scheduler"
  ]
  tags = var.tags
}


