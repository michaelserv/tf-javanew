## Terraform AWS MSK Cluster

Terraform code to create [Msk Kafka Cluster](https://aws.amazon.com/msk/) resource on AWS.

## Built with:

* Terraform (v0.13.0)
* AWS_ACCESS_KEYS and AWS_SECRET_ACCESS_KEYS are set as environment variables (link: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

### Step by Step deployment
* **Step 1: Clone the Repo.**. This command will clone the repo
```shell script
$ git clone https://github.com/antonio-rufo/tf-javanew.git
```

* **Step 2: Update the `variables.tf` file to include your vpc_id (line 48), msk_subnet_ids (line 54), and msk_security_group_ids (line 60).**
```shell script
$ cd tf-javanew
$ vi variables.tf
```
* **Step 3: Create the resources.**
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional_tags | A mapping of additional tags to assign to all resources. | `map(string)` | `{}` | no |
| region | Region where resources will be created. | `string` | `"us-east-1"` | no |
| app_name | Application name abbreviation. Cannot be more than 5 characters long and no less than 2 and must also be lower case. | `string` | `"app"` | no |
| costcenter | Costcenter associated with these resoures. | `string` | `cc` | no |
| encryption\_at\_rest\_kms\_key\_arn | You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest. | `string` | `""` | no |
| encryption\_in\_transit\_client\_broker | Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS\_PLAINTEXT, and PLAINTEXT. Default value is TLS\_PLAINTEXT. | `string` | `"TLS_PLAINTEXT"` | no |
| encryption\_in\_transit\_in\_cluster | Whether data communication among broker nodes is encrypted. Default value: true. | `bool` | `true` | no |
| environment | Environment the resources are being provisioned for. Valid options are 'prod', 'uat', 'dev', 'qa' 'sandbox'. | `string` | `"dev"` | no |
| msk_subnet_ids | List of subnet IDs to use for MSK private subnets. | `list(string)` | `["subnet-XXXXXXXX", "subnet-XXXXXXXX"]` | no |
| msk_security_group_ids | A list of security group IDs to assign to the MSK cluster. | `list(string)` | `["sg-XXXXXXXX"]` | no |
| owner | Resource owners Active Directory user id. | `string` | `"owner"` | no |
| vpc_id | ID of the VPC in which MSK will be attached. | `string` | `vpc-XXXXXXXX` | no |

## Outputs

| Name | Description |
|------|-------------|
| bootstrap\_brokers\_tls | TLS connection host:port pairs. |
| zookeeper\_connect\_string | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster. |
