locals {
  cluster_name    = "eks_cluster"
  vpc_name        = "eks_cluster"
  eks_userarn     = "arn:aws:iam::<account_id>:user/cansel_test"
  eks_username    = "cansel_test"
  common_tags = {
    terraform = var.terraform
  }
}

variable "environment" {
}

variable instance_type_nodes {
    default = "m5.large"
}

variable desired_nodes {
    type = number
    default = 3
}

#tags
variable "terraform" {
  default = "True"
}



