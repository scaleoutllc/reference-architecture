resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "acme_registration" "main" {
  account_key_pem = tls_private_key.main.private_key_pem
  email_address   = "info@wescaleout.com"
}


resource "aws_iam_policy" "main" {
  name = local.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "route53:GetChange",
        "Resource" : "arn:aws:route53:::change/*"
      },
      {
        "Effect" : "Allow",
        "Action" : "route53:ChangeResourceRecordSets",
        "Resource" : "arn:aws:route53:::hostedzone/*"
      },
      {
        "Effect" : "Allow",
        "Action" : "route53:ListHostedZonesByName",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "main" {
  name = local.name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}

resource "aws_iam_user" "main" {
  name = local.name
}

resource "aws_iam_group" "main" {
  name = local.name
}

resource "aws_iam_user_group_membership" "main" {
  user   = aws_iam_user.main.name
  groups = [aws_iam_group.main.name]
}

resource "aws_iam_policy_attachment" "main" {
  name       = local.name
  policy_arn = aws_iam_policy.main.arn
  groups     = [aws_iam_group.main.name]
}

resource "aws_iam_access_key" "main" {
  user = aws_iam_user.main.name
}
