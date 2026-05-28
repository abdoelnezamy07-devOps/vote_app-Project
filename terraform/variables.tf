variable "aws_region" {
  type = string
  default = "us-east-1"
}
variable "Cidr_block" {
  type = string
  default = "10.0.0.0/16"
}
variable "vpc_name" {
  type = string
  default = "vote-app-tr"
}

variable "public_sub" {
  type = map(any)
  default = {
    "us-east-1a"= 10
    "us-east-1b"= 20
  }
}
variable "private_sub" {
  type = map(any)
  default = {
    "us-east-1a"= 100
    "us-east-1b"= 200
  }
}

variable "outbound_alb" {
  type = list(any)
  default= ["443","80","9090","9093","8080","8081","6443","8443","443","5432","6379","10250","10251"]
  }

variable "dns" {
  type = map(any)
  default = {
    tcp= 53
    udp= 53
  }
}
