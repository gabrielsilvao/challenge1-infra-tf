variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "vpc-main"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["172.16.0.0/21", "172.16.8.0/21", "172.16.16.0/21"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["172.16.24.0/21", "172.16.32.0/21", "172.16.40.0/21"]
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets (false for HA with one per AZ)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
