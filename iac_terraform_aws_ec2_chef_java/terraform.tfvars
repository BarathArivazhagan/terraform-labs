aws_region = "us-east-1"
key_pair_name = "barath_mac_pair"
instance_type = "t2.micro"
ami = "ami-4bf3d731"
chef_user_key_filepath = "/home/ec2-user/chef-repo/.chef/barath_dec1991.pem"
node_name = "ec2-web-server-java"
chef_user_name = "barath_dec1991"
chef_server_url = "https://api.chef.io/organizations/barath-chef"
chef_client_private_key="/home/ec2-user/barath_mac_pair.pem"
chef_run_list="iac_chef_java:default"