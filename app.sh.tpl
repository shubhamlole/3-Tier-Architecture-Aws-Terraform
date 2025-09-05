#!/bin/bash

# Update package lists
sudo apt update -y

# Install required packages (MySQL client, git, curl)
sudo apt install -y mysql-client git curl

# Wait for RDS to be available
for i in {1..10}; do
    mysql -h ${db_endpoint} -u ${db_username} -p'${db_password}' -e "SELECT 1;" && break
    echo "Waiting for RDS database..."
    sleep 15
done

# Run SQL commands on RDS
mysql -h ${db_endpoint} -u ${db_username} -p'${db_password}' <<EOSQL
CREATE DATABASE IF NOT EXISTS webappdb;
USE webappdb;
CREATE TABLE IF NOT EXISTS transactions (
    id INT NOT NULL AUTO_INCREMENT,
    amount DECIMAL(10,2),
    description VARCHAR(100),
    PRIMARY KEY(id)
);
INSERT INTO transactions (amount, description) VALUES (400, 'groceries');
EOSQL

# Go to home directory
cd /home/ubuntu

# Clone the repo
git clone https://github.com/iamtejasmane/aws-three-tier-web-app.git

# Move the app-tier folder to home and remove others
mv aws-three-tier-web-app/application-code/app-tier /home/ubuntu/
rm -rf aws-three-tier-web-app

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Load NVM for current session
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
source ~/.bashrc

# Install Node.js 16 and set it for this session
nvm install 16
nvm use 16

# Install PM2 globally
npm install -g pm2

# Update DbConfig.js with RDS connection details
cat <<EOT > /home/ubuntu/app-tier/DbConfig.js
module.exports = Object.freeze({
    DB_HOST : '${db_endpoint}',
    DB_USER : '${db_username}',
    DB_PWD : '${db_password}',
    DB_DATABASE : 'webappdb'
});
EOT

# Go to app-tier folder, install dependencies, start app
cd /home/ubuntu/app-tier
npm install
pm2 start index.js --name webapp

# Configure PM2 to start on reboot
NODE_PATH=$(which node)
PM2_PATH=$(which pm2)
env PATH=$PATH:$NVM_DIR/versions/node/v16.0.0/bin $PM2_PATH startup systemd -u ubuntu --hp /home/ubuntu

# Save current PM2 process list
pm2 save
