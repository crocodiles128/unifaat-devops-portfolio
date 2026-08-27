data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid     = "AllowEc2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "technova_ec2_role" {
  name               = "${local.name_prefix}-technova-ec2-role"
  path               = "/technova/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = local.common_tags
}

data "aws_iam_policy_document" "ec2_s3_app_data" {
  statement {
    sid = "ListAppDataBuckets"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::technova-app-data-*",
    ]
  }

  statement {
    sid = "ReadWriteAppDataObjects"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::technova-app-data-*/*",
    ]
  }
}

resource "aws_iam_policy" "ec2_s3_app_data" {
  name        = "${local.name_prefix}-technova-ec2-s3-app-data"
  path        = "/technova/"
  description = "Permite leitura e escrita do EC2 nos buckets technova-app-data-*."
  policy      = data.aws_iam_policy_document.ec2_s3_app_data.json
  tags        = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ec2_s3_app_data" {
  role       = aws_iam_role.technova_ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_app_data.arn
}

resource "aws_iam_instance_profile" "technova_ec2_profile" {
  name = "${local.name_prefix}-technova-ec2-profile"
  path = "/technova/"
  role = aws_iam_role.technova_ec2_role.name
  tags = local.common_tags
}

