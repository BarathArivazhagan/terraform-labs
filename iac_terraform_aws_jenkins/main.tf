provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

module "jenkins_security_groups" {

  source = "./security-groups"
  vpc_id            = "${var.vpc_id}"
  jenkins_sg_name   = "${var.jenkins_sg_name}"

}

module "jenkins_master" {
  source = "./jenkins-master"
  vpc_id                  = "${var.vpc_id}"
  ami                     = "${var.ami}"
  public_subnet_id        = "${var.public_subnet_id}"
  security_group_ids      = ["${module.jenkins_security_groups.jenkins_sg_id}"]
  master_lb_name          = "${var.master_lb_name}"
  master_lb_subnets       = "${var.master_lb_subnets}"
  master_lb_sg            = ["${module.jenkins_security_groups.jenkins_sg_id}"]
  master_lb_ssl_cert      = "${var.elb_ssl_cert}"
  key_pair_name           = "${var.key_pair_name}"
  instance_type           = "${var.instance_type}"
  root_block_volume_size  = "${var.root_block_volume_size}"
  target_group_name       = "${var.target_group_name}"
}

module "jenkins_slave" {
  source = "./jenkins-slave"

  ami                    = "${var.ami}"
  subnet_id              = "${var.public_subnet_id}"
  security_group_ids     = ["${module.jenkins_security_groups.jenkins_sg_id}"]
  key_pair_name          = "${var.key_pair_name}"
  instance_type          = "${var.instance_type}"
  root_block_volume_size = "${var.root_block_volume_size}"

}



module "jenkins_route53" {
  source = "./route53"

  hosted_zone_id        = "${var.dns_zone_id}"
  master_record_name    = "${var.master_record_name}"
  lb_dns_name           = "${module.jenkins_master.master_lb_dns}"
  lb_zone_id            = "${module.jenkins_master.master_lb_zoneid}"
}


