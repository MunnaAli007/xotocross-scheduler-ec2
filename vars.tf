
variable "ami" {
  description = "xotocross amazon machine image"
  type = map(string)
  default = {
    default = "ami-00ac45f3035ff009e"
  }
}

variable "xotocross-availability-zones" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

variable "xotocross-vpc-cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "xotocross-private-subnets" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "xotocross-bucket-name" {
  description = "xotocross instance name"
  type = string
  default = "xotocross_bucket_name"
}

variable "xotocross-public-subnets" {
    type = list(string)
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "xotocross-master-node-count" {
    type = number
    default = 1
}

variable "xotocross-worker-node-count" {
    type = number
    default = 2
}

variable "xotocross-ssh-user" {
    type = string
    default = "ubuntu"
}

variable "xotocross-master-instance-type" {
    type = string
    default = "t3.small"
}

variable "xotocross-worker-instance-type" {
    type = string
    default = "t3.micro"
}