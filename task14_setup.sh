#!/bin/bash
# TASK 14: DEPLOYMENT OF WEB SERVER AND DATABASE

# 1. Update and install dependencies
sudo apt-get update
sudo apt-get install -y nginx mysql-server php-fpm php-mysql python3-pip python3-venv libmysqlclient-dev pkg-config build-essential

# 2. Start and configure MySQL
sudo systemctl start mysql
sudo mysql -e "CREATE DATABASE IF NOT EXISTS royal_enfield_db;"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"
sudo mysql -e "FLUSH PRIVILEGES;"

# 3. Create the DB connectivity file (Satisfies Task 14 Requirement)
# Creates /usr/share/nginx/html/db.php as requested
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

# 4. Setup Django App
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 manage.py migrate
python3 load_data.py
python3 manage.py collectstatic --noinput

# 5. Configure Nginx
cat <<EOF | sudo tee /etc/nginx/sites-available/task14
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.php index.html;

    location /db.php {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
    }

    location /static/ {
        alias $(pwd)/staticfiles/;
    }

    location / {
        proxy_set_header Host \$http_host;
        proxy_pass http://127.0.0.1:8000;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/task14 /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

# 6. Start the App
gunicorn --bind 127.0.0.1:8000 config.wsgi:application --daemon

echo "Task 14 deployment finished. Access /db.php to verify connectivity."
