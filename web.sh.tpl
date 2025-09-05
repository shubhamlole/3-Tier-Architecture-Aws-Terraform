#!/bin/bash
apt update -y
apt install -y git curl nginx

# Create nginx user
id -u nginx &>/dev/null || useradd -r -s /sbin/nologin nginx

# Clone repo
cd /home/ubuntu
git clone https://github.com/iamtejasmane/aws-three-tier-web-app.git
mv /home/ubuntu/aws-three-tier-web-app/application-code/web-tier /home/ubuntu/
cp /home/ubuntu/aws-three-tier-web-app/application-code/nginx.conf /etc/nginx/nginx.conf

# Update nginx.conf
sed -i 's|/home/ec2-user/web-tier/build|/home/ubuntu/web-tier/build|g' /etc/nginx/nginx.conf
sed -i "s|\[REPLACE-WITH-INTERNAL-LB-DNS\]|${internal_lb_dns}|g" /etc/nginx/nginx.conf

# Fix permissions BEFORE restarting nginx
chmod -R 755 /home/ubuntu

systemctl restart nginx
systemctl enable nginx

# Install NVM + Node.js 16
export HOME=/home/ubuntu
export NVM_DIR="$HOME/.nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

nvm install 16
nvm use 16

# Build React frontend
cd /home/ubuntu/web-tier
npm install
npm run build
