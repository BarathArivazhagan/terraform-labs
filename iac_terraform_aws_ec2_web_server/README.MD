# aws_ec2_web_server

Terraform script to create a simple EC2 instance in AWS. 

## Pre-requisites:

* AWS account
* EC2 instance with an IAM role (EC2FullAccess) attached # below terraform commands run from an EC2 instance to avoid security issues related to aws access key and secret
* In case of AWS marketplace amis, accept the license before we run terraform commands

# How to run the terraform script? 

* Clone the repository 
```
git clone https://github.com/BarathArivazhagan/terraform_scripts.git
```
* cd into the repository and run terraform init command

```
$ cd terraform_scripts/iac_terraform_aws_ec2_web_server
$ terraform init

```

* Plan the infrastructure using terraform plan

```
$ terraform plan
```

* Run terraform apply command to apply the changes:

```
$ terraform apply
```

# How to customize the configurations ?

Go to terraform.tfvars and modify the variables

<b> Note </b>: By default terraform populates all the configuration properties
               from terraform.tfvars.


# How to destroy the infrastructure ?

```
$ terraform destroy

```
