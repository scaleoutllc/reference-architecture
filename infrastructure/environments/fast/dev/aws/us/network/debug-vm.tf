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

module "debug" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  ami                         = data.aws_ami.ubuntu.id
  name                        = "debug"
  instance_type               = "t2.micro"
  key_name                    = "tkellen"
  vpc_security_group_ids      = [aws_security_group.debug-ssh.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\nsudo apt-get update && sudo apt-get install netcat-openbsd -y"
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

output "debug-vm" {
  value = "ubuntu@${module.debug.public_ip}"
}

output "debug-vm-private-ip" {
  value = module.debug.private_ip
}

