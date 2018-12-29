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
}

output "private_ip" {
  value = "${aws_instance.jenkins_master_instance.public_ip}"
}

output "instance_id" {
  value = "${aws_instance.jenkins_master_instance.id}"
}

resource "null_resource" "jenkins_remote_provisioner" {

  provisioner "file" {
    source      = "artifacts/jenkins_master_script.sh"
    destination = "/opt/script.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /opt/script.sh","/opt/script.sh"]


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
  load_balancer_type = "network"
  security_groups = ["${var.master_lb_sg}"]
  subnets         = "${var.master_lb_subnets}"

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.master_lb_ssl_cert}"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = ["${aws_instance.jenkins_master_instance.id}"]
  cross_zone_load_balancing   = true
  internal                    = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.master_lb_name}"
  }
}

output "master_lb_dns" {
  value = "${aws_lb.jenkins_master_lb.dns_name}"
}

output "master_lb_zoneid" {
  value = "${aws_lb.jenkins_master_lb.zone_id}"
}
