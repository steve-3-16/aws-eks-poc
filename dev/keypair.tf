# ============================================================
# 1. Local Key Pair
# Private key : Local PC only
# Public key  : Terraform
# ============================================================

resource "aws_key_pair" "bastion" {
  key_name = "a-key-steve-dev-ane2-bastion-local01"

  public_key = file(
    "${path.module}/keys/a-key-steve-dev-ane2-bastion-local01.pub"
  )

  tags = merge(
    local.common_tags,
    {
      Name = "a-key-steve-dev-ane2-bastion-local01"
    }
  )
}

resource "tls_private_key" "bastion_terraform" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "bastion_terraform" {
  key_name   = "a-key-steve-dev-ane2-bastion-terraform01"
  public_key = tls_private_key.bastion_terraform.public_key_openssh

  tags = merge(
    local.common_tags,
    {
      Name = "a-key-steve-dev-ane2-bastion-terraform01"
    }
  )
}
