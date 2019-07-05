# iac_terraform_aws_ec2_java_docker

Terraform script to create a simple EC2 instance with local provisioner

### Pre-requisites:

* <b> AWS account </b>
* <b> EC2 instance with an IAM role </b> (EC2FullAccess) attached below terraform commands run from an EC2 instance to avoid security issues related to aws access key and secret
* <b> Terraform package to be installed </b>
* <b> In case of AWS marketplace AMI </b>, accept the license before running the terraform commands

### How to run the terraform script?

* Clone the repository 
```
git clone https://github.com/BarathArivazhagan/terraform_scripts.git
```
* cd into the repository and run <b>terraform init</b> command

```
$ cd terraform_scripts/iac_terraform_aws_ec2_chef_java
$ terraform init

```

* Plan the infrastructure using <b>terraform plan</b>

```
$ terraform plan
```

* Run <b>terraform apply</b> command to apply the changes:

```
$ terraform apply
```

### How to customize the configurations ?

Go to <b>terraform.tfvars</b> and modify the variables

<b> Note </b>: By default terraform populates all the configuration properties
               from terraform.tfvars.

### How to destroy the infrastructure ?

```
$ terraform destroy
```
