# Input variable definitions
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_name" {
  description = "tmt-proj1-vpc"
  type        = string
  default     = "tmt-proj1-vpc"
}

variable "ami" {
  description = "ami string"
  type        = string
  default     = "ami-036d46416a34a611c"
}

variable "vpc_security_group_name" {
  description = "tmt-proj1-vpc-sg"
  type        = string
  default     = "tmt-proj1-vpc-sg"
}


variable "vpc_cidr" {
  description = "tmt-proj1-vpc-cidr"
  type        = string
  default     = "10.0.0.0/24"
}


variable "my_ip" {
  description = "tmt-proj1-vpc-myip"
  type        = list(string)
  default     = ["50.82.222.12/32"]
}


variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}


variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.0.0/26", "10.0.0.64/26"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.0.128/26", "10.0.0.192/26"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = false
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}
