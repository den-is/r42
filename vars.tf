variable "myip" {
  type = "string"
}

variable "pubip" {
  type    = "string"
}

variable "profile" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "vpcid" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "ubuntu_ami_id" {
  type    = "map"
  default = {
    "eu-central-1" = "ami-6283ef0d"
    "eu-west-1"    = "ami-70054309"
  }
}

variable "assign_public_ip" {
  type    = "string"
  default = "false"
}
