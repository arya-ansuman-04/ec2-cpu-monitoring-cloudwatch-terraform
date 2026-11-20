provider "aws" {
  region = "ap-south-1"
}

# Reuse existing VPC
data "aws_vpc" "existing" {
  id = "vpc-02c0842f98e27f4e6"
}

# Reuse existing subnet
data "aws_subnet" "existing" {
  id = "subnet-0cbba03e4b0449c01"
}

# Reuse existing security group
data "aws_security_group" "web_sg" {
  id = "sg-0aa976a5e1e25c00d"
}

# EC2 instance
resource "aws_instance" "monitoring_server" {
  ami                         = "ami-0f918f7e67a3323f0"
  instance_type                = "t2.micro"
  subnet_id                   = data.aws_subnet.existing.id
  vpc_security_group_ids       = [data.aws_security_group.web_sg.id]
  associate_public_ip_address  = true

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y stress
    nohup stress --cpu 2 --timeout 1800 > /var/log/stress.log 2>&1 &
  EOF

  tags = {
    Name = "capstone-cloudwatch-server"
  }
}

# CloudWatch CPU Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "capstone-ec2-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic            = "Average"
  threshold            = 20
  alarm_description    = "Alarm when EC2 CPU utilization exceeds 20%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.monitoring_server.id
  }
}

output "instance_id" {
  value = aws_instance.monitoring_server.id
}

output "public_ip" {
  value = aws_instance.monitoring_server.public_ip
}

output "alarm_name" {
  value = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name
}
