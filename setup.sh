#!/bin/bash
# =================================================================
# ROYAL ENFIELD UBUNTU DEPLOYMENT SCRIPT (MANUAL DB MODE)
# =================================================================

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

# 3. STATIC FILES SETUP
echo "📦 Collecting Static Files..."
python3 manage.py collectstatic --noinput

# 4. CONFIGURE NGINX (DJANGO PROXY)
echo "🌐 Configuring Nginx..."
cat <<EOF | sudo tee /etc/nginx/sites-available/royalenfield
server {
    listen 80;
    server_name _;

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

sudo ln -sf /etc/nginx/sites-available/royalenfield /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

# 5. START GUNICORN
echo "⚡ Starting Application Server..."
gunicorn --bind 127.0.0.1:8000 config.wsgi:application --daemon

echo "================================================================"
echo "✨ SYSTEM SETUP COMPLETE ✨"
echo "================================================================"
echo "IMPORTANT MANUAL STEPS:"
echo "1. Update config/settings.py with your DB endpoint and credentials."
echo "2. Run 'source venv/bin/activate' then 'python3 manage.py migrate'."
echo "3. Run 'python3 load_data.py' to populate the bike fleet."
echo "4. Verify connectivity manually using your preferred tools."
echo "================================================================"
