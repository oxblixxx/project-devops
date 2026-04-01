I had an issue, were apache2 was the hosted webser, there were 2 service both frontend and backend, also the frontend was in laravel hosted over https and the backend was hosted in node, and was started with PM2, so now, the backend api is up, functioning, but the uploads directory for image wasn't working. This conf file was used to resolve the issue

```sh
<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerName laundry.appentus.cloud
    #ServerAlias laundryonapp.com

    # Keep original host header
    ProxyPreserveHost On

    # Allow proxying
    <Proxy *>
        Require all granted
    </Proxy>
    ProxyPass /uploads/ !
    Alias /uploads /var/www/html/LAUNDRY-BE/uploads
    <Directory /var/www/html/LAUNDRY-BE/uploads>
        Require all granted
        Options +Indexes
    </Directory>
    # Proxy /uploads to Node backend
    ProxyPass / http://127.0.0.1:3000
    ProxyPassReverse / http://127.0.0.1:3000

    # Optional: proxy other backend routes if needed
    # ProxyPass /api http://127.0.0.1:3000/api
    # ProxyPassReverse /api http://127.0.0.1:3000/api
#    Alias /uploads /var/www/LAUNDRY-BE/uploads
#    <Directory /var/www/html/LAUNDRY-BE/uploads>
#        Require all granted
#        Options +Indexes
#    </Directory>

    # Logging
    ErrorLog ${APACHE_LOG_DIR}/node-error.log
    CustomLog ${APACHE_LOG_DIR}/node-access.log combined

SSLCertificateFile /etc/letsencrypt/live/laundry.appentus.cloud/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/laundry.appentus.cloud/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
</IfModule>
````
