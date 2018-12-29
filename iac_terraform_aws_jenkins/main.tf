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

  ami                = "${var.ami}"
  public_subnet_id  = "${var.public_subnet_id}"
  security_group_ids = ["${module.jenkins_security_groups.jenkins_sg_id}"]
  master_elb_name     = "${var.master_elb_name}"
  master_elb_subnets  = ["${var.public_subnet_id}"]
  master_elb_sg       = ["${module.jenkins_security_groups.jenkins_sg_id}"]
  master_elb_ssl_cert = "${var.elb_ssl_cert}"
  key_pair_name = "${var.key_pair_name}"
  ssh_key_private = "${var.ssh_private_key}"
}

module "jenkins_slave" {
  source = "./jenkins-slave"

  ami                = "${var.ami}"
  subnet_id          = "${var.public_subnet_id}"
  security_group_ids = ["${module.jenkins_security_groups.jenkins_sg_id}"]
  key_pair_name = "${var.key_pair_name}"

}



module "jenkins_route53" {
  source = "./route53_elbs"

  hosted_zone_id = "${var.dns_zone_id}"
  master_record_name    = "${var.master_record_name}"
  elb_dns_name   = "${module.jenkins_master.master_elb_dns}"
  elb_zone_id    = "${module.jenkins_master.master_elb_zoneid}"
}


