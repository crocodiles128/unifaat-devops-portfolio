data "aws_iam_policy_document" "technova_s3_read" {
  statement {
    sid = "ListTechNovaBuckets"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::technova-*",
    ]
  }

  statement {
    sid = "ReadTechNovaObjects"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::technova-*/*",
    ]
  }
}

resource "aws_iam_policy" "technova_s3_read" {
  name        = "${local.name_prefix}-technova-s3-read"
  path        = "/technova/"
  description = "Permite leitura em buckets S3 technova-*."
  policy      = data.aws_iam_policy_document.technova_s3_read.json
  tags        = local.common_tags
}

data "aws_iam_policy_document" "technova_ec2_s3_full" {
  statement {
    sid = "DescribeEc2"

    actions = [
      "ec2:Describe*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "StartStopTaggedEc2"

    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
    ]

    resources = ["arn:aws:ec2:*:*:instance/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    sid = "ListTechNovaBuckets"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::technova-*",
    ]
  }

  statement {
    sid = "ReadWriteTechNovaObjects"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::technova-*/*",
    ]
  }
}

resource "aws_iam_policy" "technova_ec2_s3_full" {
  name        = "${local.name_prefix}-technova-ec2-s3-full"
  path        = "/technova/"
  description = "Permite Describe EC2, Start/Stop em EC2 tagueado e leitura/escrita S3."
  policy      = data.aws_iam_policy_document.technova_ec2_s3_full.json
  tags        = local.common_tags
}

data "aws_iam_policy_document" "technova_deny_destructive" {
  statement {
    sid    = "DenyDestructiveActions"
    effect = "Deny"

    actions = [
      "*:Delete*",
      "*:Terminate*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "technova_deny_destructive" {
  name        = "${local.name_prefix}-technova-deny-destructive"
  path        = "/technova/"
  description = "Deny explicito para acoes destrutivas em EC2 e S3."
  policy      = data.aws_iam_policy_document.technova_deny_destructive.json
  tags        = local.common_tags
}

resource "aws_iam_group_policy_attachment" "developers_s3_read" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.technova_s3_read.arn
}

resource "aws_iam_group_policy_attachment" "developers_deny_destructive" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.technova_deny_destructive.arn
}

resource "aws_iam_group_policy_attachment" "platform_eng_ec2_s3_full" {
  group      = aws_iam_group.platform_eng.name
  policy_arn = aws_iam_policy.technova_ec2_s3_full.arn
}
