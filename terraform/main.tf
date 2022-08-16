module "eks" {
    source = "./modules/eks"
    cluster_name = local.cluster_name
    subnet_ids = module.vpc.private_subnets
    vpc_id = module.vpc.vpc_id
    instance_type_nodes = var.instance_type_nodes
    desired_nodes = var.desired_nodes
    eks_userarn = local.eks_userarn
    eks_username = local.eks_username
    tags = local.common_tags
}

module "vpc" {
    source = "./modules/vpc"
    vpc_name = local.vpc_name
    azs = data.aws_availability_zones.available.names
    cluster_name = local.cluster_name
}

module "sg" {
    source = "./modules/sg"
    sg_name = "iem_eks_cluster_sg"
    vpc_id = module.vpc.vpc_id
}