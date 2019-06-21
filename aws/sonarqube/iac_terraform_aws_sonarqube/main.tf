provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"


}


resource "aws_db_instance" "sonarqube-db" {
  name = "${var.sonar_database_name}"
  instance_class = "db.t2.micro"
  identifier = "${var.sonar_database_name}"
  vpc_security_group_ids = ["${aws_security_group.rds_sonarqube_security_group.id}"]
  db_subnet_group_name = "${var.db_subnet_group_name}"
  allocated_storage = "${var.db_allocated_storage}"
  engine = "mysql"
  engine_version       = "${var.db_engine_version}"
  parameter_group_name = "default.mysql5.6"
  username = "${var.sonar_master_username}"
  password = "${var.sonar_master_password}"
  port = 3306

}

output "sonarqube_db_rds_endpoint" {
  value = "${aws_db_instance.sonarqube-db.endpoint}"
}



resource "aws_security_group" "rds_sonarqube_security_group" {

  name        = "${var.rds_db_security_group_name}"
  description = "RDS security group for mysql database engine"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.rds_db_security_group_name}"
  }


}


# This resource block creates AWS EC2 instance with the details provided
resource "aws_instance" "sonarqube-instance" {

  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${aws_security_group.default_allow_all_sg.id}"]
  subnet_id = "${var.subnet_id}"
  tags {
    Name = "sonarqube-instance"
  }

  depends_on = ["aws_db_instance.sonarqube-db"]
  # chef provisioner configuration
  provisioner "chef" {
    node_name = "${var.node_name}"
    server_url = "${var.chef_server_url}"
    user_key = "${file(var.chef_user_key_filepath)}"
    user_name = "${var.chef_user_name}"
    run_list = "${var.chef_run_list}"
    environment = "${var.chef_environment}"
    recreate_client = true

    connection {
      type = "ssh"
      user = "${var.ssh_connection_user}"
      private_key = "${file(var.chef_client_private_key)}"
    }
  }
}

# This resource block creates AWS Secutiry Group within VPC ID with the details provided
resource "aws_security_group" "default_allow_all_sg" {
  name        = "default_allow_all_sg"
  description = "Allow all inbound traffic"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}