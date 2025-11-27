variable "servers" {
    default = {
        workshop-gpu     = "g5.xlarge",
        workshop-storage = "m6id.2xlarge"
        }
    }

variable "server_names" {
    default = [
                "workshop-gpu",   
                "workshop-storage"
                ]

    }

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "mykey" {
  key_name   = "terraform-key"
  public_key = file("/home/bdavy/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "ssh" {

  ingress {
    description = "SSH from my any IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jupyter HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jupyter HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  server_map = { for name in var.server_names : name => var.servers[name] }
}

resource "aws_instance" "app_server" {
  for_each                    = local.server_map
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = each.value
  key_name                    = aws_key_pair.mykey.key_name
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  associate_public_ip_address = true
  tags = {
    Name = each.key

  }
}

output "public_ips" {
  value = { for name, inst in aws_instance.app_server : name => inst.public_ip }
}

output "private_ips" {
  value = { for name, inst in aws_instance.app_server : name => inst.private_ip }
}

