provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

}

data "template_file" "docker_build_template" {
  template = "${file("../templates/docker_build.tpl")}"

  vars {
    ecr_repository_url = "docker-hub"
    ecr_repository_name = "dockerregistry"
  }
}


resource "null_resource" "docker_configuration" {


  provisioner "file" {
    destination = "/home/centos/docker_build"
    source = "../templates/docker_build.tpl"
  }

}

