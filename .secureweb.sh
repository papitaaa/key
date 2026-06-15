#!/bin/bash

# Variables
DOMAIN="www.pakya.local"
SERVER_IP="192.169.110.128"
WEB_SERVER="apache2"
HOMEPAGE_CONTENT="Welcome to DITISS"
CERT_DIR="/etc/ssl/$DOMAIN"
APACHE_CONF="/etc/apache2/sites-available/$DOMAIN.conf"
CA_CERT="/root/pki/subca.crt"       # Path to your Sub CA certificate
SERVER_CERT="/root/pki/$DOMAIN.crt" # Path to your server certificate signed by Sub CA
SERVER_KEY="/root/pki/$DOMAIN.key"  # Path to your server private key

echo "=== Setting up HTTPS website for $DOMAIN ==="

# Step 1: Map domain to IP in /etc/hosts
if ! grep -q "$DOMAIN" /etc/hosts; then
    echo "$SERVER_IP    $DOMAIN" | sudo tee -a /etc/hosts
fi

# Step 2: Install Apache and SSL modules
sudo apt update
sudo apt install -y $WEB_SERVER openssl

sudo a2enmod ssl
sudo a2enmod rewrite

# Step 3: Create SSL directory and copy certs
sudo mkdir -p $CERT_DIR
sudo cp $SERVER_CERT $CERT_DIR/
sudo cp $SERVER_KEY $CERT_DIR/
sudo cp $CA_CERT $CERT_DIR/

# Step 4: Create custom homepage
echo "<html><head><title>$DOMAIN</title></head><body><h1>$HOMEPAGE_CONTENT</h1></body></html>" | sudo tee /var/www/html/index.html

# Step 5: Configure Apache VirtualHost
sudo bash -c "cat > $APACHE_CONF" <<EOF
<VirtualHost *:443>
    ServerName $DOMAIN
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile $CERT_DIR/$DOMAIN.crt
    SSLCertificateKeyFile $CERT_DIR/$DOMAIN.key
    SSLCertificateChainFile $CERT_DIR/subca.crt

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Step 6: Enable site and restart Apache
sudo a2ensite $DOMAIN.conf
sudo systemctl reload apache2

# Step 7: Add Sub CA certificate to Firefox trust store
echo "Adding Sub CA certificate to Firefox..."
PROFILE_DIR=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.default*" | head -n 1)
if [ -n "$PROFILE_DIR" ]; then
    certutil -A -n "DITISS SubCA" -t "CT,C,C" -i $CA_CERT -d sql:$PROFILE_DIR
    echo "Sub CA certificate added to Firefox profile."
else
    echo "Firefox profile not found. Please import $CA_CERT manually."
fi

echo "=== Setup complete. Test https://$DOMAIN in Firefox ==="

