provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

}

data "template_file" "docker_build_template" {
  template = "${var.template_source_path}"

  vars = {
    ecr_repository_url = "${var.docker_repository_url}"
    ecr_repository_name = "${var.docker_repository_name}"
  }
}


resource "null_resource" "docker_configuration" {


  provisioner "file" {
    destination = "${var.template_destination_path}"
    content = "${data.template_file.docker_build_template.rendered}"
  }

  provisioner "local-exec" {
    command = "sh ${var.template_destination_path}"
  }

  connection {


    type = "ssh"
    user = "${var.user}"
    private_key = "${file(var.private_key_path)}"
  }

}

