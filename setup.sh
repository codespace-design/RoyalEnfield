#!/bin/bash
# =================================================================
# ROYAL ENFIELD MASTER DEPLOYMENT SCRIPT (PORT 8000)
# =================================================================

# CHECK FOR SETTINGS UPDATE
echo "⚠️  IMPORTANT: Have you updated 'config/settings.py' with your Database credentials?"
echo "If not, the database connection will fail."
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting. Please update settings.py and run again."
    exit 1
fi

# 1. INSTALL SYSTEM DEPENDENCIES (UBUNTU)
echo "🚀 Installing Ubuntu System Packages..."
sudo apt-get update
sudo apt-get install -y nginx python3-pip python3-venv libmysqlclient-dev pkg-config build-essential

# 2. SETUP VIRTUAL ENVIRONMENT & INSTALL REQUIREMENTS
echo "🐍 Setting up Python Environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

pip install --upgrade pip
pip install Django>=5.0 mysqlclient pymysql django-environ gunicorn whitenoise

# 3. INITIALIZE DATABASE & DATA
echo "🗄️ Preparing Migrations..."
python3 manage.py makemigrations

echo "🚀 Running Migrations..."
python3 manage.py migrate

echo "🏍️ Loading Bike Fleet Data..."
python3 load_data.py

# 4. STATIC FILES SETUP
echo "📦 Collecting Static Files..."
python3 manage.py collectstatic --noinput

# 5. CONFIGURE NGINX (OPTIONAL PROXY)
echo "🌐 Configuring Nginx (Proxying Port 80 to 8000)..."
cat <<EOF | sudo tee /etc/nginx/sites-available/royalenfield
server {
    listen 80;
    server_name _;

    location /static/ {
        alias $(pwd)/staticfiles/;
    }

    location / {
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_pass http://127.0.0.1:8000;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/royalenfield /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

# 6. START GUNICORN (BIND TO 0.0.0.0:8000)
echo "⚡ Starting Application Server on 0.0.0.0:8000..."
pkill gunicorn || true
gunicorn --bind 0.0.0.0:8000 config.wsgi:application --daemon

echo "================================================================"
echo "✨ AUTOMATED DEPLOYMENT COMPLETE ✨"
echo "================================================================"
echo "Your application is now running on Port 8000 and Port 80."
echo "Access via: http://<YOUR-AWS-IP>:8000/"
echo "================================================================"
