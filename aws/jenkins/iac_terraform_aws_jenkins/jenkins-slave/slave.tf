resource "aws_instance" "jenkins_slave_instance" {

  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_block_volume_size}"
  }
  vpc_security_group_ids = ["${var.security_group_ids}"]

  tags = {
    Name          = "jenkins-slave-instance"
  }

  key_name = "${var.key_pair_name}"
  provisioner "file" {
    source      = "./artifacts/jenkins_slave_script.sh"
    destination = "/home/ec2-user/script.sh"

    connection {
      host        = "${aws_instance.jenkins_slave_instance.public_ip}"
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("./artifacts/jenkins.pem")}"
    }
  }
}

resource "null_resource" "jenkins_slave_remote_provisioner" {


  provisioner "remote-exec" {
    inline = ["sudo chmod +x /home/ec2-user/script.sh","/home/ec2-user/script.sh"]


    connection {
      host        = "${aws_instance.jenkins_slave_instance.public_ip}"
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("./artifacts/jenkins.pem")}"
    }
  }

}

output "jenkins_slave_instance_public_ip" {
  value = "${aws_instance.jenkins_slave_instance.public_ip}"
}

output "jenkins_slave_instance_id" {
  value = "${aws_instance.jenkins_slave_instance.id}"
}


