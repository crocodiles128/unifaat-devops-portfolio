resource "aws_iam_group" "developers" {
  name = "${local.name_prefix}-technova-developers"
  path = "/technova/"
}

resource "aws_iam_group" "platform_eng" {
  name = "${local.name_prefix}-technova-platform-eng"
  path = "/technova/"
}

resource "aws_iam_user" "juliana_dev" {
  name          = "${local.name_prefix}-juliana-dev"
  path          = "/technova/"
  force_destroy = true
  tags          = local.common_tags
}

resource "aws_iam_user" "rafael_platform" {
  name          = "${local.name_prefix}-rafael-platform"
  path          = "/technova/"
  force_destroy = true
  tags          = local.common_tags
}

resource "aws_iam_user" "lucas_intern" {
  name          = "${local.name_prefix}-lucas-intern"
  path          = "/technova/"
  force_destroy = true
  tags          = local.common_tags
}

resource "aws_iam_group_membership" "developers" {
  name = "${local.name_prefix}-technova-developers-membership"

  users = [
    aws_iam_user.juliana_dev.name,
    aws_iam_user.rafael_platform.name,
    aws_iam_user.lucas_intern.name,
  ]

  group = aws_iam_group.developers.name
}

resource "aws_iam_group_membership" "platform_eng" {
  name = "${local.name_prefix}-technova-platform-eng-membership"

  users = [
    aws_iam_user.rafael_platform.name,
  ]

  group = aws_iam_group.platform_eng.name
}

