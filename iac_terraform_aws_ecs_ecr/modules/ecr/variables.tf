variable "ecr_name" {

    description = "Elastic contianer registry name"
}

variable "environment" {
  default = ""
  description = "envrionment name to be associated"
}

variable "roles" {
  type        = "list"
  description = "Principal IAM roles to provide with access to the ECR"
  default     = ["ECR_ROLE"]
}

variable "delimiter" {
  type    = "string"
  default = "-"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "max_image_count" {
  type        = "string"
  description = "How many Docker Image versions AWS ECR will store"
  default     = "7"
}

variable "user" {

  description = "user name to login through ssh connection type"
}

variable "private_key_path" {

  description = "provide the path to private key to login to the instance"
}

variable "template_source_path" {

  description = "Source path to the template"
}
variable "template_destination_path" {

  description = "Destination path to the rendered template"
}
