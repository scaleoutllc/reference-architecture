
resource "aws_iam_user" "matt" {
  name = "matt"
}

resource "aws_iam_user_policy_attachment" "admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  user       = aws_iam_user.matt.name
}

resource "aws_iam_access_key" "matt" {
  user = aws_iam_user.matt.name
}

resource "aws_iam_user_login_profile" "matt" {
  user = aws_iam_user.matt.name
}