THE SCRIPT IS TO INSTALL NGINX, WHICH INTALLS ON YUM, APT(DEBIAN/UBUNTU) THEN IT GOES AHEAD TO FORTIFY THE WEBSERVER WITH A FORTRESS CONF.

Install this " sudo apt install nginx-extras -y", then add this line "        more_set_headers "Server: Get a legal job to DO!";" in nginx.conf, test with `curl -I https://url.com`
