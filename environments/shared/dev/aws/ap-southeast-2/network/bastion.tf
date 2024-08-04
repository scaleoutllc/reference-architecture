data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "bastion" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  ami                         = data.aws_ami.ubuntu.id
  name                        = "bastion"
  instance_type               = "t2.micro"
  key_name                    = "tkellen"
  vpc_security_group_ids      = [aws_security_group.bastion-ssh.id]
  subnet_id                   = module.vpc.public_subnet_ids[0]
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\nsudo apt-get update && sudo apt-get install netcat-openbsd -y"
}

resource "aws_security_group" "bastion-ssh" {
  name   = "bastion-ssh"
  vpc_id = module.vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "bastion-ssh" {
  value = "ubuntu@${module.bastion.public_ip}"
}
