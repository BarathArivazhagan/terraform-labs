provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

}

module "ecs" {

  source = "modules/ecs"

  environment          = "${var.environment}"
  aws_region           = "${var.aws_region}"
  aws_internet_gateway_name = "${var.aws_internet_gateway_name}"
  vpc_name            = "${var.vpc_name}"
  private_subnet_cidr_a = "${var.private_subnet_cidr_a}"
  public_subnet_cidr_a = "${var.public_subnet_cidr_a}"
  vpc_cidr = "${var.vpc_cidr}"
  ecr_name = "${var.ecr_name}"
  max_image_count = "${var.max_image_count}"
  app_family_name = "${var.app_family_name}"
  ecs_cluster_name = "${var.ecs_cluster_name}"
  fargate_cpu = "${var.ecs_cluster_name}"
  fargate_memory = "${var.fargate_memory}"
  app_image = "${var.ecs_cluster_name}"
  host_port = "${var.host_port}"
  container_port = "${var.container_port}"
  container_name = "${var.container_name}"
  task_count = "${var.task_count}"



}
