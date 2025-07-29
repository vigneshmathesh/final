provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "pro-1" {
  key_name   = "pro-1"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_security_group" "my-sg-1" {
  name = "my-sg-1"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "flask_app" {
  ami                    = "ami-020cba7c55df1f615"    # Ubuntu 22.04 (verify this is correct)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.pro-1.key_name
  vpc_security_group_ids = [aws_security_group.my-sg-1.id]
  associate_public_ip_address = true   # ✅ Important for access via browser/SSH

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo docker run -d -p 5000:5000 sakthi965   # ✅ Make sure this image is public on DockerHub
              EOF

  tags = {
    Name = "project-num"
  }
}

output "instance_public_ip" {
  value = aws_instance.flask_app.public_ip
}
