#!/bin/bash
# Update system
yum update -y

# Install Apache
yum install -y httpd

# Enable and start Apache
systemctl enable httpd
systemctl start httpd

# Fetch private IP
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

#Install amazon-cloudwatch-agent
yum install amazon-cloudwatch-agent -y
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-linux -s

# simple static webpage
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>EC2 Static Website</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            text-align: center;
            padding-top: 100px;
        }
        h1 {
            color: #232f3e;
        }
        p {
            font-size: 18px;
        }
    </style>
</head>
<body>
    <h1>Hello from EC2</h1>
    <p>This is a static website hosted on EC2.</p>
    <p><strong>Private IP:</strong> ${PRIVATE_IP}</p>
</body>
</html>
EOF

chown apache:apache /var/www/html/index.html