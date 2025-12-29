#!/bin/bash

yum update -y
yum install amazon-cloudwatch-agent -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-linux -s
echo "HelloWorld from $(hostname -f)" >> /var/www/html/index.html