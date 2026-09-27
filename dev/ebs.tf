# # Bastion Secondary EBS
# resource "aws_ebs_volume" "bastion_data" {
#   availability_zone = aws_instance.bastion.availability_zone

#   type      = "gp3"
#   size      = 8
#   encrypted = true

#   tags = merge(
#     local.common_tags,
#     {
#       Name = "${local.provider}-ebs-${local.project}-${local.environment}-${local.region_code}-bastion-data01"
#     }
#   )
# }

# resource "aws_volume_attachment" "bastion_data" {
#   device_name = "/dev/sdf"
#   volume_id   = aws_ebs_volume.bastion_data.id
#   instance_id = aws_instance.bastion.id
# }
