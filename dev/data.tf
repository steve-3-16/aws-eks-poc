/*
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
*/

data "aws_key_pair" "bastion_console" {
  key_name = "a-key-steve-dev-ane2-bastion-console01"
}

# Steve Golden AMI
data "aws_ami" "golden" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["steve-al2023-golden-v1"]
  }
}

data "aws_key_pair" "web" {
  key_name = "a-key-steve-dev-ane2-bastion-console01"
}

data "aws_ami" "openvpn" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["steve-al2023-openvpn-golden-v1"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}