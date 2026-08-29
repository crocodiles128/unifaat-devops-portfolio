output "users" {
  description = "Usuarios IAM criados para o exercicio."
  value = {
    juliana_dev     = aws_iam_user.juliana_dev.name
    rafael_platform = aws_iam_user.rafael_platform.name
    lucas_intern    = aws_iam_user.lucas_intern.name
  }
}

output "groups" {
  description = "Grupos IAM criados para separacao de responsabilidades."
  value = {
    developers   = aws_iam_group.developers.name
    platform_eng = aws_iam_group.platform_eng.name
  }
}

output "policy_arns" {
  description = "ARNs das policies customizadas."
  value = {
    s3_read            = aws_iam_policy.technova_s3_read.arn
    ec2_s3_full        = aws_iam_policy.technova_ec2_s3_full.arn
    deny_destructive   = aws_iam_policy.technova_deny_destructive.arn
    ec2_s3_app_data_rw = aws_iam_policy.ec2_s3_app_data.arn
  }
}

output "role_arn" {
  description = "ARN da role usada por EC2."
  value       = aws_iam_role.technova_ec2_role.arn
}

output "instance_profile_name" {
  description = "Nome do instance profile associado a role EC2."
  value       = aws_iam_instance_profile.technova_ec2_profile.name
}

