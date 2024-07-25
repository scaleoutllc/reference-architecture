data "tfe_outputs" "aws-us-network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-network"
}

data "tfe_outputs" "aws-au-network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-au-network"
}

data "tfe_outputs" "aws-us-cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-cluster"
}

data "tfe_outputs" "aws-au-cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-au-cluster"
}

resource "aws_security_group_rule" "us-allow-au-ingress" {
  provider          = aws.us
  description       = "Let the US cluster receive traffic from the AU cluster."
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = data.tfe_outputs.aws-us-cluster.values.primary_security_group_id
  cidr_blocks       = [data.tfe_outputs.aws-au-network.values.config.cidr]
}

resource "aws_security_group_rule" "au-allow-us-ingress" {
  provider          = aws.au
  description       = "Let the AU cluster receive traffic from the US cluster."
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = data.tfe_outputs.aws-au-cluster.values.primary_security_group_id
  cidr_blocks       = [data.tfe_outputs.aws-us-network.values.config.cidr]
}
