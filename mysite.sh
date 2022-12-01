#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
cd /tmp/
wget https://www.tooplate.com/zip-templates/2121_wave_cafe.zip
unzip 2121_wave_cafe
cd 2121_wave_cafe
cp -r * /var/www/html/
systemctl restart httpd