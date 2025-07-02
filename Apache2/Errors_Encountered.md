# Apache Redirect Configuration

## Table of Contents
- [Redirect `www.zzzz.com` → `zzzz.com`](#apache-redirect-wwwzzzzcom--zzzzcom)

7.3. How do I know if my Apache server is working?
Access your server using your favorite SSH client.
Enter the following command: sudo service apache2 status.
If Apache is running, you will see the following message Apache is running (pid 26874).
7.4. What does Apache include?
Apache has modules for :

Security ;
Caching;
URL rewriting;
Password authentication;
And so on
You can also adjust your own server settings via a file called .htaccess, which is an Apache configuration file.

7.5. How is the Apache server installed?
To install apache as a service :

In the Windows menu, search for: cmd;
Run cmd with administrator rights;
Go to the \ apache : cd c:\Apache24\bin.
Install the service with the instruction : httpd.exe -k install.
Finally, start apache with the instruction : httpd.exe -k start.
7.6. How do I know if I am using Apache?
There are several ways to know the software used by our server, one of them is to use tools such as GTMetrix, Pingdom…

The easiest way would be to analyze the website via Pingdom, from the File Requests section.

7.7. What communication port does the Apache web server use?
By default, the Apache HTTP server is configured to listen on port 80 for insecure web communications and on port 443 for secure web communications.

7.8. What are the versions of Apache?
There are currently three versions of Apache running: versions 2.0, 2.2 and 2.4. Previously, there was version 1.3 which is the best known and the one that meant the big expansion of the server.

7.9. How do I start, restart or stop the Apache server?
To start, stop or restart Apache as a web server, you just need to access the terminal of your server via ssh and execute one of the following commands:

Start Apache: /etc/init.d/ apache2 start.
Restart Apache: /etc/init.d/ apache2 restart.
Stop Apache: /etc/init.d/apache2 stop . 5/5 – (3 votes)
7.10. how does Apache work?
As a web server, Apache is responsible foraccepting directory requests (HTTP) from Internet users and sending them the desired informationin the form of files and web pages

Most web software and code is designed to work with Apache’s functionality.

7.what is MySQL and PHP in Apache?
Apache is the web server that processes requests and serves web resources and content via HTTP

MySQL is the database that stores all your information in an easily searchable format.

PHP is the programming language that works with Apache to help create dynamic web content.

7.12. Can Nginx replace Apache?
Both solutions are capable of handling various workloads. Although Apache and Nginx share many qualities, they should not be considered entirely interchangeable.

7.13. Is Nginx the same as Apache?
The main difference between Apache and NGINX is their design architecture

Apache uses a process-oriented approach and creates a new thread for each request. NGINX, on the other hand, uses an event-driven architecture to handle multiple requests within a single thread.

In summary
As we have seen before, Apache is the Web server that thousands of hosting companies around the world work with.

It is ideal for small and medium-sized businesses that want to be present in the digital world. Very compatible with WordPress that allows you to work in a simple and orderly way.

I hope this guide has helped you weigh the pros and cons to make the right decision for your project!

Thanks for reading and see you soon!

CategoriesWebsite Creation
2 thoughts on “Apache Server : A Complete Beginner’s Guide”
# Apache Redirect: `www.zzzz.com` → `zzzz.com`
Ensure to change the ServerAlias to www.zzz.com. Then modify the server block as shown below

## 1. HTTP (Port 80) - Redirect to HTTPS + non-www
```apache
<VirtualHost *:80>
    ServerName zzzz.com
    ServerAlias www.zzzz.com

    # Force HTTPS and non-www
    RewriteEngine On
    RewriteCond %{HTTPS} off [OR]
    RewriteCond %{HTTP_HOST} ^www\.zzzz\.com [NC]
    RewriteRule ^(.*)$ https://zzzz.com/$1 [L,R=301]
</VirtualHost>
```
2. HTTPS (Port 443) - Remove www
```apache
<VirtualHost *:443>
    ServerName zzzz.com
    ServerAlias www.zzzz.com

    # Remove www (HTTPS only)
    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\.zzzz\.com [NC]
    RewriteRule ^(.*)$ https://zzzz.com/$1 [L,R=301]
</VirtualHost>
```
Key Notes:
Placement: Add these rules inside the respective <VirtualHost> blocks.
Testing: Use curl -I http://zzzz.com to verify redirects.
