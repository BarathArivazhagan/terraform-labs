terraform {
  required_version = ">= 0.14.7"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.29.0"
    }
  }
}

provider "aws" {
  region = "var.aws_region"
}


data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  cluster_name = join("-",[var.stack_name,"eks"])
  subnets = tonumber(var.number_of_subnets)
  # the commented out worker group list below shows an example of how to define
  # multiple worker groups of differing configurations
   worker_groups = [
     {
       asg_desired_capacity = 2
       asg_max_size = 10
       asg_min_size = 2
       instance_type = "m4.xlarge"
       name = "worker_group_a"
     },
     {
       asg_desired_capacity = 1
       asg_max_size = 5
       asg_min_size = 1
       instance_type = "m4.2xlarge"
       name = "worker_group_b"
     },
   ]


  # the commented out worker group tags below shows an example of how to define
  # custom tags for the worker groups ASG
  # worker_group_tags = {
  #   worker_group_a = [
  #     {
  #       key                 = "k8s.io/cluster-autoscaler/node-template/taint/nvidia.com/gpu"
  #       value               = "gpu:NoSchedule"
  #       propagate_at_launch = true
  #     },
  #   ],
  #   worker_group_b = [
  #     {
  #       key                 = "k8s.io/cluster-autoscaler/node-template/taint/nvidia.com/gpu"
  #       value               = "gpu:NoSchedule"
  #       propagate_at_launch = true
  #     },
  #   ],
  # }

  worker_groups_launch_template = [
    {
      # This will launch an autoscaling group with only Spot Fleet instances
      instance_type                            = "t2.micro"
      additional_userdata                      = "echo foo bar"
      subnets                                  = join(",", module.vpc.private_subnets)
      #additional_security_group_ids            = "${aws_security_group.worker_group_mgmt_one.id},${aws_security_group.worker_group_mgmt_two.id}"
      override_instance_type                   = "t3.xlarge"
      asg_desired_capacity                     = "2"
      spot_instance_pools                      = 10
      on_demand_percentage_above_base_capacity = "0"
    },
  ]
  tags = {
    environment = "demo"
    stack_name = var.stack_name
  }
}


module "vpc" {
  source             = "./vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  subnets            = local.subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  stack_name         = var.stack_name

}

module "eks" {
  source                               = "./eks"
  cluster_name                         = local.cluster_name
  cluster_version                      = var.cluster_version
  subnets                              = module.vpc.private_subnets
  tags                                 = local.tags
  vpc_id                               = module.vpc.vpc_id
  worker_groups                        = local.worker_groups
  worker_groups_launch_template        = local.worker_groups_launch_template
  worker_group_count                   = "1"
  worker_group_launch_template_count   = "1"
  map_roles                            = var.map_roles
  map_roles_count                      = var.map_roles_count
  map_users                            = var.map_users
  map_users_count                      = var.map_users_count
  map_accounts                         = var.map_accounts
  map_accounts_count                   = var.map_accounts_count
}
