/*
resource "aws_instance" "bastion" {
  #ami                     = data.aws_ami.al2023.id
  ami                     = var.bastion_ami_id
  instance_type           = "t3.micro"
  disable_api_termination = false

  key_name = aws_key_pair.bastion.key_name
  #key_name = data.aws_key_pair.bastion_console.key_name
  #key_name = aws_key_pair.bastion_terraform.key_name

  subnet_id                   = aws_subnet.public["public_a"].id
  private_ip                  = cidrhost(aws_subnet.public["public_a"].cidr_block, 10)
  associate_public_ip_address = var.associate_public_ip

  vpc_security_group_ids = [
    aws_security_group.bastion.id,
    aws_security_group.common.id
  ]

  iam_instance_profile = aws_iam_instance_profile.bastion.name

  user_data = file("${path.module}/scripts/bastion-userdata.sh")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = var.enable_imds_v2 ? "required" : "optional"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-ec2-${local.project}-${local.environment}-${local.region_code}-bastion01"
    }
  )
}
*/

/*resource "aws_instance" "web" {
  count = var.web_instance_count

  ami           = data.aws_ami.golden.id
  instance_type = var.web_instance_type

  subnet_id              = aws_subnet.compute[count.index].id
  vpc_security_group_ids = [aws_security_group.web.id]

  associate_public_ip_address = false
  key_name                    = data.aws_key_pair.web.key_name

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name = "steve-web-${count.index + 1}"
  }
}*/


# ============================================================
# OpenVPN EC2 - Custom Golden AMI
# ============================================================

/*resource "aws_instance" "openvpn" {
  ami           = data.aws_ami.openvpn.id
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.public["public_a"].id
  vpc_security_group_ids      = [aws_security_group.openvpn.id]
  associate_public_ip_address = true

  # VPN Routing
  source_dest_check = false

  # SSH Key Pair
  key_name = data.aws_key_pair.web.key_name

  # EBS Root Volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  # EC2 Initialization
  user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail

    exec > >(tee -a /var/log/openvpn-init.log) 2>&1

    echo "=== OpenVPN EC2 initialization started ==="

    # Enable IP Forwarding
    echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-openvpn.conf
    sysctl -w net.ipv4.ip_forward=1

    # Start OpenVPN Firewall Service
    systemctl enable --now openvpn-firewall.service

    # Start OpenVPN Server
    systemctl enable --now openvpn-server@server.service

    echo "=== OpenVPN EC2 initialization completed ==="
  EOF

  # IMDSv2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Resource Tags
  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-ec2-${local.project}-${local.environment}-${local.region_code}-openvpn01"
    }
  )
}*/
