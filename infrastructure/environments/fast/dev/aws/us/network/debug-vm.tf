module "debug" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  name                        = "debug"
  instance_type               = "t2.micro"
  key_name                    = "tkellen"
  vpc_security_group_ids      = [aws_security_group.debug-ssh.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
}

resource "aws_security_group" "debug-ssh" {
  name   = "debug-ssh"
  vpc_id = module.vpc.vpc_id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "debug_vm_public_ip" {
  value = module.debug.public_ip
}
