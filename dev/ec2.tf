resource "aws_instance" "bastion" {
  ami                     = data.aws_ami.al2023.id
  instance_type           = "t3.micro"
  disable_api_termination = false

  #key_name = aws_key_pair.bastion.key_name
  #key_name = data.aws_key_pair.bastion_console.key_name
  key_name = aws_key_pair.bastion_terraform.key_name

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
