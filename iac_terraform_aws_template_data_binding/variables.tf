variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key to access AWS resources"
  default = "" # Not recommended to use access key as it leads to secutiry issues
}


variable "aws_secret_key" {
  description = "AWS secret key to access AWS resources"
  default = "" # Not recommended to use secret key as it leads to secutiry issues
}

variable "user" {

  description = "user name to login through ssh connection type"
}

variable "private_key_path" {

  description = "provide the path to private key to login to the instance"
}

variable "docker_repository_name" {

  description = "name of the docker repository"
}


variable "template_source_path" {

  description = "Source path to the template"
}
variable "template_destination_path" {

  description = "Destination path to the rendered template"
}