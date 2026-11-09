mock_provider "aws" {}

variables {
  name                 = "test"
  cidr_block           = "10.0.0.0/16"
  azs                  = ["ca-central-1a", "ca-central-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}

run "single_nat_by_default" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 2 && length(aws_subnet.private) == 2
    error_message = "Expected one public and one private subnet per AZ."
  }

  assert {
    condition     = length(aws_nat_gateway.this) == 1
    error_message = "Expected a single shared NAT gateway by default."
  }
}

run "nat_per_az" {
  command = plan

  variables {
    single_nat_gateway = false
  }

  assert {
    condition     = length(aws_nat_gateway.this) == 2
    error_message = "Expected one NAT gateway per AZ."
  }
}

run "no_nat" {
  command = plan

  variables {
    enable_nat_gateway = false
  }

  assert {
    condition     = length(aws_nat_gateway.this) == 0 && length(aws_route.private_nat) == 0
    error_message = "Expected no NAT gateways or private default routes."
  }
}
