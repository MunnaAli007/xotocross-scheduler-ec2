
module "xotocross-vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "xotocross-${var.xotocross-bucket-name}-vpc"
  cidr = var.xotocross-vpc-cidr

  azs             = var.xotocross-availability-zones
  private_subnets = var.xotocross-private-subnets
  public_subnets  = var.xotocross-public-subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  create_igw = true
  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}