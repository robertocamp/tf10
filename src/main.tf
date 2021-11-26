# # Terraform configuration

# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#     }
#   }
# }

# provider "aws" {
#   region = "us-west-2"
# }

locals {
  service_name = "tmt-proj1"
  owner        = "@robertocamp"
}

variable "vpc_create_db_subnet_group" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = false
}



module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway
  create_database_subnet_group = true

  tags = var.vpc_tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  # name        = local.service_name
  name        = var.vpc_security_group_name
  description = "Security group for example usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  # ingress_cidr_blocks = ["0.0.0.0/0"]
  # ingress_rules       = ["http-80-tcp", "all-icmp"]
  ingress_cidr_blocks =  var.my_ip
  ingress_rules = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]

  #tags = local.tags
  tags  = var.vpc_tags
}


module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "tmt-proj1"
  instance_count = 2
  // ubuntu t2 micro
  ami                    =  var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# start with stock config example from:
# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest


module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  # identifier = "demodb"
  identifier = "${local.service_name}-db"

  engine            = "mysql"
  engine_version    = "5.7.34"
  instance_class    = "db.t2.large"
  allocated_storage = 5

  name     = "${local.service_name}-db"

  username = "${local.service_name}-db"

  password = "${local.service_name}-db"

  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval = "30"
  # monitoring_role_name = "MyRDSMonitoringRole"
  # create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  # subnet_ids = ["subnet-12345678", "subnet-87654321"]
  subnet_ids = module.vpc.database_subnets

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]
}
