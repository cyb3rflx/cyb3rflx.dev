terraform {
  backend "s3" {
    bucket       = "cyb3rflx-tfstate"
    key          = "infra/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}



provider "aws" {
  region = "eu-central-1"

}

provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}

