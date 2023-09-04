
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "cluster_name" { 
  type = string 
}

variable "vpc_name" { 
  type = string 
}

variable "k8s_version" { 
  type = string 
}
