This directory discusses about apache2 setup, securing apache2, and common errors.


To install Apache2 and certbot

```sh
sudo apt install certbot python3-certbot-apache -y
```

Then run below command to get started and setup SSL with already existing `ServerName` in Conf file

```sh
sudo certbot
```

So one thing, incase the `domain` is not handled by cloudflare to provide extra layer of security to hide the server public ip address and to avoid users still been able to access the website from the public ip address. Simply Edit the Apache port 80 config:

```sh
sudo nano /etc/apache2/sites-available/000-default.conf
```

Add this:

```sh
<VirtualHost *:80>
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com

    Redirect permanent / https://yourdomain.com/
</VirtualHost>
```
