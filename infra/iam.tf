resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

data "aws_iam_policy_document" "oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      identifiers = [aws_iam_openid_connect_provider.github.arn]
      type        = "Federated"
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }

    condition {
      test     = "StringEquals"
      values   = ["repo:cyb3rflx@178774788/cyb3rflx.dev@1301356547:ref:refs/heads/main"]
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

resource "aws_iam_role" "github" {
  assume_role_policy = data.aws_iam_policy_document.oidc.json
  name               = "github-oidc-role"
}

data "aws_iam_policy_document" "s3_cloudfront" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.website_bucket.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = [aws_cloudfront_distribution.s3_distribution.arn]
  }
}

resource "aws_iam_policy" "s3_cloudfront" {
  policy      = data.aws_iam_policy_document.s3_cloudfront.json
  name        = "s3-cloudfront-deploy-policy"
  description = "Policy used for deployments on CI"
}

resource "aws_iam_role_policy_attachment" "github" {
  role       = aws_iam_role.github.name
  policy_arn = aws_iam_policy.s3_cloudfront.arn
}