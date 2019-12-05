variable "AWS_REGION" {
  type = string
  default = "eu-west-2"
}

variable "XPS_IP" {
  type = string
  default = "31.11.128.233/32"
}

variable "EC2_USER" {
  default = "ubuntu"
}

variable "AMI" {
    type = "map"

    default = {
        eu-west-2 = "ami-0be057a22c63962cb"
        us-east-1 = "ami-04b9e92b5572fa0d1"
    }
}