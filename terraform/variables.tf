variable "domain" {
  description = "Primary domain name"
  type        = string
  default     = "joe-hill.me"
}

variable "aws_region" {
  description = "AWS region for regional resources (S3, etc.)"
  type        = string
  default     = "us-east-1"
}
