#!/bin/bash
# =================================================================
# ROYAL ENFIELD ALL-IN-ONE AWS DEPLOYMENT SCRIPT (TASK 14)
# =================================================================

# 1. INSTALL SYSTEM DEPENDENCIES
echo "🚀 Installing System Stack..."
sudo apt-get update
sudo apt-get install -y nginx mysql-server php-fpm php-mysql \
    python3-pip python3-venv libmysqlclient-dev pkg-config build-essential

# 2. CONFIGURE DATABASE
echo "🗄️ Configuring MySQL..."
sudo systemctl start mysql
sudo mysql -e "CREATE DATABASE IF NOT EXISTS royal_enfield_db;"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"
sudo mysql -e "FLUSH PRIVILEGES;"

# 3. CREATE TASK 14 VERIFICATION FILE
echo "✅ Creating DB Connectivity Verification File..."
sudo mkdir -p /usr/share/nginx/html
cat <<EOF | sudo tee /usr/share/nginx/html/db.php
<?php
\$conn = new mysqli("localhost", "root", "root", "royal_enfield_db");
if (\$conn->connect_error) {
    die("❌ Connection Failed: " . \$conn->connect_error);
}
echo "<h1>✅ Database Connectivity: SUCCESSFUL</h1>";
echo "<p>Connected to <b>royal_enfield_db</b> on MySQL.</p>";
?>
EOF

# 4. SETUP VIRTUAL ENVIRONMENT & INSTALL REQUIREMENTS
echo "🐍 Setting up Python Environment..."
python3 -m venv venv
source venv/bin/activate

# Installing requirements directly in script for single-file portability
pip install --upgrade pip
pip install Django>=5.0 mysqlclient django-environ gunicorn whitenoise

# 5. INITIALIZE APPLICATION
echo "📦 Initializing Application..."
python3 manage.py migrate
python3 load_data.py
python3 manage.py collectstatic --noinput

# 6. CONFIGURE NGINX
echo "🌐 Configuring Nginx..."
cat <<EOF | sudo tee /etc/nginx/sites-available/royalenfield
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.php index.html;

    # Task 14 PHP Verification
    location /db.php {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
    }

    # Django Static Files
    location /static/ {
        alias $(pwd)/staticfiles/;
    }

    # Django Application
    location / {
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_pass http://127.0.0.1:8000;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/royalenfield /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

# 7. START GUNICORN
echo "⚡ Starting Application Server..."
gunicorn --bind 127.0.0.1:8000 config.wsgi:application --daemon

echo "================================================================"
echo "✨ DEPLOYMENT SUCCESSFUL ✨"
echo "Check connectivity at: http://your-aws-ip/db.php"
echo "View the fleet at: http://your-aws-ip/"
echo "================================================================"
