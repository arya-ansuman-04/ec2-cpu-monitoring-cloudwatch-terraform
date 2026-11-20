# EC2 CPU Monitoring with CloudWatch Alarm using Terraform

## Objective

Deploy an EC2 instance using Terraform and monitor its CPU utilization using Amazon CloudWatch. Configure an alarm to trigger when CPU utilization exceeds a specified threshold.

## Tools Used

- AWS EC2
- Amazon CloudWatch
- Terraform
- AWS CLI
- Ubuntu

## Implementation

1. Created an EC2 instance using Terraform.
2. Configured the instance to generate CPU load using the stress utility.
3. Created a CloudWatch alarm to monitor CPU utilization.
4. Configured the alarm threshold to 20%.
5. Generated CPU load to test the alarm.
6. Verified that the alarm successfully transitioned to ALARM state.

## Configuration

- Instance Type: t2.micro
- Monitoring Metric: CPUUtilization
- Threshold: 20%
- Period: 300 seconds (5 minutes)
- Evaluation Periods: 1

## Result

Successfully deployed an EC2 instance and configured CloudWatch monitoring. When CPU utilization exceeded 20%, the CloudWatch alarm transitioned to ALARM state.

## GitHub Repository

https://github.com/arya-ansuman-04/ec2-cpu-monitoring-cloudwatch-terraform
