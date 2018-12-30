resource "aws_instance" "jenkins_master_instance" {

  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.public_subnet_id}"
  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_block_volume_size}"
  }
  vpc_security_group_ids = ["${var.security_group_ids}"]

  tags = {
    Name          = "jenkins-master-instance"
  }
  key_name = "${var.key_pair_name}"
  provisioner "file" {
    source      = "./artifacts/jenkins_master_script.sh"
    destination = "/home/ec2-user/script.sh"

    connection {
      host        = "${aws_instance.jenkins_master_instance.public_ip}"
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("./artifacts/jenkins.pem")}"
    }
  }
}

output "jenkins_master_public_ip" {
  value = "${aws_instance.jenkins_master_instance.public_ip}"
}

output "instance_id" {
  value = "${aws_instance.jenkins_master_instance.id}"
}

resource "null_resource" "jenkins_remote_provisioner" {


  provisioner "remote-exec" {
    inline = ["sudo chmod +x /home/ec2-user/script.sh","/home/ec2-user/script.sh"]


    connection {
      host        = "${aws_instance.jenkins_master_instance.public_ip}"
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("./artifacts/jenkins.pem")}"
    }
  }

}

resource "aws_lb" "jenkins_master_lb" {
  name = "${var.master_lb_name}"
  load_balancer_type = "application"
  security_groups = ["${}"]
  subnets         = "${var.master_lb_subnets}"
  internal                    = false
  enable_deletion_protection = true

  tags {
    Name = "${var.master_lb_name}"
  }
}

resource "aws_lb_target_group" "jenkins_lb_target_group" {
  port = 8080
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  target_type = "instance"

  tags {
    Name = "jenkins_lb_target_group"
  }
}

resource "aws_lb_target_group_attachment" "jenkins_lb_target_group_attachment" {
  target_group_arn = "${aws_lb_target_group.jenkins_lb_target_group.arn}"
  target_id = "${aws_instance.jenkins_master_instance.id}"
  port = 8080
}

resource "aws_lb_listener" "jenkins_lb_listener" {

  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = "${var.master_lb_ssl_cert}"
  protocol = "HTTPS"
  "default_action" {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.jenkins_lb_target_group.arn}"
  }
  load_balancer_arn = "${aws_lb.jenkins_master_lb.arn}"
  port = 443
}





output "master_lb_dns" {
  value = "${aws_lb.jenkins_master_lb.dns_name}"
}

output "master_lb_zoneid" {
  value = "${aws_lb.jenkins_master_lb.zone_id}"
}
