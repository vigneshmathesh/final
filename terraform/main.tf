provider "aws" {
  region = "us-east-1"
}

# ✅ Use your existing security group
resource "aws_security_group" "my_sg" {
  name        = "my-sg-2-renamed"
  description = "Allow SSH and Flask traffic"
  vpc_id      = "vpc-03e88fa0d29499332"  # ✅ Your correct VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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

# ✅ EC2 instance using existing key pair
resource "aws_instance" "flask_app" {
  ami                    = "ami-020cba7c55df1f615"  # Ubuntu 20.04
  instance_type          = "t2.micro"
  key_name               = "pro-1"  # ✅ Use existing key (not creating new one)
  subnet_id              = "subnet-054107beef0c6a4d9"  # ✅ Your correct subnet
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo docker run -d -p 5000:5000 sakthi965
              EOF

  tags = {
    Name = "my-instance-1"
  }
}

# ✅ Optional Output
output "instance_public_ip" {
  value = aws_instance.flask_app.public_ip
}
