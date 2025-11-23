#!/bin/bash
# Apache2 Fortress Hardening Script
# Applies secure headers, custom server banner, and optional ModSecurity integration
# Run as a sudo user
set -e

BANNER='AdminSaidNoHackingAllowed'
MODSEC_CONF='/etc/modsecurity/hide_server_tokens.conf'
APACHE2_CONF='/etc/apache2/apache2.conf'
SECURITY_CONF='/etc/apache2/conf-available/security.conf'

echo "[*] Backing up configs..."
cp -v $SECURITY_CONF{,.bak}
cp -v $APACHE2_CONF{,.bak}

echo "[*] Enabling Apache security config..."
a2enconf security || true

echo "[*] Setting ServerTokens Full and disabling signature..."
sed -i 's/^ServerTokens.*/ServerTokens Full/' $SECURITY_CONF
sed -i 's/^ServerSignature.*/ServerSignature Off/' $SECURITY_CONF
grep -q '^ServerTokens' $SECURITY_CONF || echo "ServerTokens Full" >> $SECURITY_CONF
grep -q '^ServerSignature' $SECURITY_CONF || echo "ServerSignature Off" >> $SECURITY_CONF

echo "[*] Adding security headers..."
cat <<EOF >> $SECURITY_CONF

# -- START fortress headers --
Header always set X-Content-Type-Options "nosniff"
Header always set X-Frame-Options "DENY"
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
Header always set X-Permitted-Cross-Domain-Policies "none"
Header always unset X-Powered-By
#Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
Header always set Permissions-Policy "geolocation=(), microphone=(), camera=(), fullscreen=(self)"Header always set Content-Security-Policy "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdnjs.cloudflare.com https://cdn.jsdelivr.net https://stackpath.bootstrapcdn.com; font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com; script-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com https://cdn.jsdelivr.net https://stackpath.bootstrapcdn.com https://code.jquery.com;"
# -- END fortress headers --
EOF

echo "[*] Enabling headers module..."
a2enmod headers || true

echo "[*] Restarting/reloading Apache..."
systemctl reload apache2 || systemctl restart apache2

echo "[*] Installing ModSecurity if needed..."
apt update
apt install -y libapache2-mod-security2

echo "[*] Enabling ModSecurity module..."
a2enmod security2 || true
systemctl restart apache2

echo "[*] Setting custom ModSecurity server banner..."
echo "SecServerSignature \"$BANNER\"" > $MODSEC_CONF
if ! grep -qF "$MODSEC_CONF" $APACHE2_CONF; then
    echo "IncludeOptional $MODSEC_CONF" >> $APACHE2_CONF
fi

echo "[*] Restarting Apache with final config..."
systemctl restart apache2

echo "[*] Fortress hardening complete."
