#!/bin/bash

yum update -y
yum install amazon-cloudwatch-agent -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "HelloWorld from $(hostname -f)" >> /var/www/html/index.html