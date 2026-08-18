variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "nimbus"
}

variable "github_repository" {
  type        = string
  description = "GitHub OWNER/REPOSITORY used in the OIDC trust policy"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "allowed_ingress_cidr" {
  type        = string
  description = "CIDR allowed to reach the staging API. Restrict this to your IP for a real environment."
  default     = "0.0.0.0/0"
}
