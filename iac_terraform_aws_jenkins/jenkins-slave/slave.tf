resource "aws_instance" "jenkins_slave_instance" {

  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
  }
  vpc_security_group_ids = ["${var.security_group_ids}"]

  tags = {
    Name          = "jenkins-slave-instance"
  }

  key_name = "${var.key_pair_name}"
}

output "public_ip" {
  value = "${aws_instance.jenkins_slave_instance.public_ip}"
}

output "jenkins_slave_instance_id" {
  value = "${aws_instance.jenkins_slave_instance.id}"
}



resource "null_resource" "jenkins_slave_remote_exec" {

}
