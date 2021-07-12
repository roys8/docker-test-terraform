locals {
  instance-userdata = <<EOF
#!/bin/bash
export PATH=$PATH:/usr/local/bin
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
aws configure set default.region us-east-1
aws ecr get-login-password --region us-east-1| sudo docker login --username AWS --password-stdin 335010663577.dkr.ecr.us-east-1.amazonaws.com
sudo docker run -p 5000:5000 335010663577.dkr.ecr.us-east-1.amazonaws.com/test-ecr-repo:1
EOF
}

resource "aws_instance" "es-jenkins-az1" {
  ami                         = "ami-0dc2d3e4c0f9ebd18"
  user_data_base64            = base64encode(local.instance-userdata)
  availability_zone           = "us-east-1c"
  ebs_optimized               = false
  instance_type               = "t2.micro"
  monitoring                  = true
  key_name                    = "test-jenkins"
  subnet_id                   = "subnet-5107040c"
  vpc_security_group_ids      = ["sg-00ec7209f00230976"]
  associate_public_ip_address = true
  iam_instance_profile        = "test-role"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
  provisioner "file" {
    source      = "credentials"
    destination = "/var/credentials"
  }

  tags = {
    Name = "ec2-jenkins"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "kdg"
}