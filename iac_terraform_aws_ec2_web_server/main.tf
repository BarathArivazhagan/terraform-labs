provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web-server" {
  ami = "ami-4bf3d731"
  instance_type = "t2.micro"
  key_name = "barath_mac_pair"
  
  tags {
    Name = "web-server"
  }
}

resource "aws_security_group" "default_allow_all_sg" {
  name        = "default_allow_all_sg"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}