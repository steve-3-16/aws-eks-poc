resource "aws_iam_role" "bastion" {
  name = "a-iamro-steve-dev-ane2-bastion01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "a-iamro-steve-dev-ane2-bastion01"
  }
}

resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "a-iamip-steve-dev-ane2-bastion01"
  role = aws_iam_role.bastion.name
}
