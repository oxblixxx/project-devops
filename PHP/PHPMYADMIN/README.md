# PHPMyAdmin Setup and Security Notes
This directory includes the setup of phpmyadmin which can be setup with script.sh and can be accessed via `http://$SERVER_IP/phpmyadmin`. And a subdomain can be added using apache or nginx can be used. 

If not going to add a subdomain, it security wise to modify the alias to a different path.


This directory includes tools and scripts to help you set up phpMyAdmin.  
**Always follow security best practices before exposing phpMyAdmin to the internet!**

---

## Quick Install

- Install using the setup [script](PHP/PHPMYADMIN/install_php_my_admin.sh).

- Default access via:  
`http://$SERVER_IP/phpmyadmin`

- **Optional:** Set up a subdomain for phpMyAdmin.  
- For Apache, use: [install_php_my_admin.sh](PHP/PHPMYADMIN/install_php_my_admin.sh)
- For Nginx, use: [php_admin_nginx.conf](PHP/PHPMYADMIN/php_admin_nginx.conf)

---

## Hide Default Alias for Security

Attackers often scan for the default `/phpmyadmin` path.  
For better security, change it to a random/unique path.

1. Open the Apache config file:
  ```sh
  sudo nano /etc/phpmyadmin/apache.conf
  ```

2. Find the line:
  ```sh
  Alias /phpmyadmin /usr/share/phpmyadmin
  ```

3. Replace `/phpmyadmin` with a random string (example `/my-rand-3948`):
  ```sh
  Alias /my-rand-3948 /usr/share/phpmyadmin
  ```

4. Reload apache for changes:
  ```
  sudo systemctl reload apache2
  ```

- Now you can access phpMyAdmin at `http://$SERVER_IP/my-rand-3948`

---

## Additional Recommended Security Steps

- **Restrict by IP:**  
Limit access to phpMyAdmin only from trusted IPs.  
Add inside `<Directory /usr/share/phpmyadmin>` block in `/etc/phpmyadmin/apache.conf`:

```sh
<Directory /usr/share/phpmyadmin>
    Require ip 192.168.1.100
    Require ip 203.0.113.77
    # Add more trusted IPs as needed
    Require all denied
</Directory>
```

- **Keep phpMyAdmin updated:**  
Always keep your installation current to avoid known vulnerabilities.

---
