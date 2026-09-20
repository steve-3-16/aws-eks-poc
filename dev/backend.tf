terraform {
  backend "s3" {
    bucket       = "sunggwan-terraform-tfstate-s3"
    key          = "eks-poc/dev/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
