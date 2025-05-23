# INTRODUCTION
Hi, I am Cau

This is my personal project about infrastructuring an **AWS-based Microservices Deployments Management**.

The project has the infratructure itself, with the main files for provisioning are under folder:  
<pre>.\environments\dev</pre>
This project also comes with a small infratructure of a self-hosted Jenkins, you can find files for this Jenkins instance at:  
<pre>.\jenkins\infra</pre>
I also added a simple **Jenkinsfile**, which should be used to build and push Docker images of the microservices onto AWS ECR.  
Jenkinsfile is located at:  
<pre>.\jenkins\pipelines</pre>
There are also .yml files that are used to setup pods for this project, access to them at:  
<pre>.\kubectl\dev\ui-service
.\kubectl\dev\api-gateway
.\kubectl\dev\backend-service
.\kubectl\dev\database-service
.\kubectl\dev\database</pre>

My infrastructure design:

![clound-infra](design.png)

# REQUIRED REPOSITORIES

There are 5 repositories needed, I have written each **Dockerfile** for each repository, refer to each of them for preview:  

*Just FYI: In each repository I also added Github Actions workflows&actions, feel free to check them out!*  

[cloud infra & pipeline project](https://github.com/DoCau/deployment-mgmt-infra)  
[ui-service](https://github.com/DoCau/deployment-mgmt-ui-service)  
[api-gateway](https://github.com/DoCau/deployment-mgmt-api-gateway)  
[backend-service](https://github.com/DoCau/deployment-mgmt-backend-service)  
[database-service](https://github.com/DoCau/deployment-mgmt-database-service)  

# PROJECT COMPONENTS
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ../../modules/ecr | n/a |
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | ../../modules/eks | n/a |
| <a name="module_iam_role"></a> [iam\_role](#module\_iam\_role) | ../../modules/iam | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../../modules/network | n/a |
| <a name="module_security_groups"></a> [security\_groups](#module\_security\_groups) | ../../modules/security-group | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | ID of the aws account | `string` | n/a | yes |
| <a name="input_bastion_host_ami"></a> [bastion\_host\_ami](#input\_bastion\_host\_ami) | Ami of a OS. Usually in format: ami-xxxxxxxxxxxxxx. Recommend using Ubuntu | `string` | n/a | yes |
| <a name="input_bastion_host_instance_type"></a> [bastion\_host\_instance\_type](#input\_bastion\_host\_instance\_type) | Type of AMI instance. Usually in format: t2.micro, t2.medium,... | `string` | n/a | yes |
| <a name="input_bastion_private_key_file_path"></a> [bastion\_private\_key\_file\_path](#input\_bastion\_private\_key\_file\_path) | Path to save the .pem key file. Example: secr/locked/keys/this-is-the-key.pem | `string` | n/a | yes |
| <a name="input_bastion_public_key_file_path"></a> [bastion\_public\_key\_file\_path](#input\_bastion\_public\_key\_file\_path) | Path to save the .pub key file. Example: secr/locked/keys/this-is-the-key.pub | `string` | n/a | yes |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Version of EKS cluster, also version of EKS node group | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of environment: dev, stag, uat,... | `string` | n/a | yes |
| <a name="input_internet_gateway_desired_destination_cidr_block"></a> [internet\_gateway\_desired\_destination\_cidr\_block](#input\_internet\_gateway\_desired\_destination\_cidr\_block) | CIDR block to specify allowed-incoming-ip from internet gateway to public route table | `string` | `"0.0.0.0/0"` | no |
| <a name="input_list_egresses_of_bastion"></a> [list\_egresses\_of\_bastion](#input\_list\_egresses\_of\_bastion) | A list of egresses for the Bastion's security group | <pre>list(object({<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_list_egresses_of_eks"></a> [list\_egresses\_of\_eks](#input\_list\_egresses\_of\_eks) | A list of egresses for eks's security group | <pre>list(object({<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_list_egresses_of_node_group"></a> [list\_egresses\_of\_node\_group](#input\_list\_egresses\_of\_node\_group) | A list of egresses for node group's security group | <pre>list(object({<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_list_ingresses_of_eks"></a> [list\_ingresses\_of\_eks](#input\_list\_ingresses\_of\_eks) | A list of ingresses for eks's security group, but using option cidr\_blocks instead of security\_groups | <pre>list(object({<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_list_ingresses_of_node_group"></a> [list\_ingresses\_of\_node\_group](#input\_list\_ingresses\_of\_node\_group) | A list of ingresses for node group's security group, but using option cidr\_blocks instead of security\_groups | <pre>list(object({<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_nat_gateway_desired_destination_cidr_block"></a> [nat\_gateway\_desired\_destination\_cidr\_block](#input\_nat\_gateway\_desired\_destination\_cidr\_block) | CIDR block to specify allowed-incoming-ip from nat gateway to public route table | `string` | `"0.0.0.0/0"` | no |
| <a name="input_nat_subnet_availability_zone"></a> [nat\_subnet\_availability\_zone](#input\_nat\_subnet\_availability\_zone) | Availability zone of natGW-attached-subnet. Recommend using same zone with private subnet-2 | `string` | n/a | yes |
| <a name="input_nat_subnet_cidr_block"></a> [nat\_subnet\_cidr\_block](#input\_nat\_subnet\_cidr\_block) | CIDR block of public natGW-attached-subnet | `string` | n/a | yes |
| <a name="input_node_group_ami_type"></a> [node\_group\_ami\_type](#input\_node\_group\_ami\_type) | AMI type for nodes in node group. View more info here: https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType | `string` | n/a | yes |
| <a name="input_node_group_desired_size"></a> [node\_group\_desired\_size](#input\_node\_group\_desired\_size) | Desired number of active nodes | `number` | n/a | yes |
| <a name="input_node_group_disk_size"></a> [node\_group\_disk\_size](#input\_node\_group\_disk\_size) | Disk size of each node in node group - Elastic Block Storage EBS. Default 20GB if leaves blank | `number` | n/a | yes |
| <a name="input_node_group_instance_types"></a> [node\_group\_instance\_types](#input\_node\_group\_instance\_types) | List of instance types for nodes in node group. Example: ['t3.medium'] | `list(string)` | n/a | yes |
| <a name="input_node_group_max_size"></a> [node\_group\_max\_size](#input\_node\_group\_max\_size) | Maximum number of active nodes | `number` | n/a | yes |
| <a name="input_node_group_max_unavailable_nodes"></a> [node\_group\_max\_unavailable\_nodes](#input\_node\_group\_max\_unavailable\_nodes) | Number of node(s) that can be turned off to update or rollback | `number` | n/a | yes |
| <a name="input_node_group_min_size"></a> [node\_group\_min\_size](#input\_node\_group\_min\_size) | Minimum number of active nodes | `number` | n/a | yes |
| <a name="input_node_group_private_key_file_path"></a> [node\_group\_private\_key\_file\_path](#input\_node\_group\_private\_key\_file\_path) | Path to save the .pem key file. Example: secr/locked/keys/this-is-the-key.pem | `string` | n/a | yes |
| <a name="input_node_group_public_key_file_path"></a> [node\_group\_public\_key\_file\_path](#input\_node\_group\_public\_key\_file\_path) | Path to save the .pub key file. Example: secr/locked/keys/this-is-the-key.pub | `string` | n/a | yes |
| <a name="input_private_subnet_1_availability_zone"></a> [private\_subnet\_1\_availability\_zone](#input\_private\_subnet\_1\_availability\_zone) | Availability zone of private subnet-1. Recommend using same zone with public bastion-attached-subnet | `string` | n/a | yes |
| <a name="input_private_subnet_1_cidr_block"></a> [private\_subnet\_1\_cidr\_block](#input\_private\_subnet\_1\_cidr\_block) | CIDR block of private subnet-1 | `string` | n/a | yes |
| <a name="input_private_subnet_2_availability_zone"></a> [private\_subnet\_2\_availability\_zone](#input\_private\_subnet\_2\_availability\_zone) | Availability zone of private subnet-2. Recommend using same zone with natGW-attached-subnet | `string` | n/a | yes |
| <a name="input_private_subnet_2_cidr_block"></a> [private\_subnet\_2\_cidr\_block](#input\_private\_subnet\_2\_cidr\_block) | CIDR block of private subnet-2 | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of project, hyphen separated | `string` | n/a | yes |
| <a name="input_public_subnet_availability_zone"></a> [public\_subnet\_availability\_zone](#input\_public\_subnet\_availability\_zone) | Availability zone of public bastion-attached-subnet. Example: ap-southeast-2a | `string` | n/a | yes |
| <a name="input_public_subnet_cidr_block"></a> [public\_subnet\_cidr\_block](#input\_public\_subnet\_cidr\_block) | CIDR block of public bastion-attached-subnet | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block of vpc. Example: 10.0.0.0/16 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_host_private_ip"></a> [bastion\_host\_private\_ip](#output\_bastion\_host\_private\_ip) | The private IP of bastion host, this ip has nothing to do with EIP |
| <a name="output_bastion_host_public_ip"></a> [bastion\_host\_public\_ip](#output\_bastion\_host\_public\_ip) | The public IP of bastion host, but this is actually IP of EIP that connected to bastion host |
| <a name="output_eks_public_endpoint"></a> [eks\_public\_endpoint](#output\_eks\_public\_endpoint) | Endpoint for kubectl to connect to remote EKS |
| <a name="output_nat_gateway_private_ip"></a> [nat\_gateway\_private\_ip](#output\_nat\_gateway\_private\_ip) | The private IP of NAT gw, but this has nothing to do with the EIP |
| <a name="output_nat_gateway_public_ip"></a> [nat\_gateway\_public\_ip](#output\_nat\_gateway\_public\_ip) | The public IP of NAT gateway, but this is actually IP of EIP that connected to NAT gw |
