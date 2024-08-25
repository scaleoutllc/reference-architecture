data "aws_partition" "this" {}

resource "aws_acmpca_certificate_authority" "main" {
  type = "ROOT"
  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA512WITHRSA"
    subject {
      common_name = "Istio Dev CA"
    }
  }
  tags = {
    Name = local.name
  }
}

resource "aws_acmpca_certificate" "root" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.main.arn
  certificate_signing_request = aws_acmpca_certificate_authority.main.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"
  template_arn                = "arn:${data.aws_partition.this.partition}:acm-pca:::template/RootCACertificate/V1"
  validity {
    type  = "YEARS"
    value = 10
  }
}

resource "aws_acmpca_certificate_authority_certificate" "root" {
  certificate_authority_arn = aws_acmpca_certificate_authority.main.arn
  certificate               = aws_acmpca_certificate.root.certificate
  certificate_chain         = aws_acmpca_certificate.root.certificate_chain
}

resource "aws_iam_policy" "main" {
  name = local.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "acm-pca:DescribeCertificateAuthority",
          "acm-pca:GetCertificate",
          "acm-pca:IssueCertificate"
        ],
        Effect   = "Allow",
        Resource = aws_acmpca_certificate_authority.main.arn
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
