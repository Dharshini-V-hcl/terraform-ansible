provider "aws" {
  region = var.region
}

resource "aws_instance" "nginx" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "ansible"
  security_groups = [aws_security_group.nginx_sg.name]

  tags = {
    Name = "nginx-instance"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "[nginx]" > ../ansible/inventory
      echo "${self.public_ip} ansible_user=ubuntu ansible_private_key_file=../terraform/ansible.pem" >> ../ansible/inventory
    EOT
  }
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow HTTP and SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

output "public_ip" {
  value       = aws_instance.nginx.public_ip
  description = "Public IP of the Nginx server"
}

