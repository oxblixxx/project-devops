#### NGINX OFFICIAL IMAGE IS NOT USED BECAUSE IT LACKS THE NGINX-EXTRAS PACKAGE WHICH IS REQUIRED FOR THE NGINX CONFIGURATION TO PASS VAPT
#### SO, UBUNTU BASE IMAGE IS USED AND NGINX-EXTRAS PACKAGE IS INSTALLED MANUALLY
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Add Ondrej PPA and install nginx-extras
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/nginx && \
    apt-get update && \
    apt-get install -y nginx-extras && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN chmod -R 775 /var/www/ && \
    chown -R www-data:www-data /var/www 

RUN rm -f /etc/nginx/sites-enabled/default
# Expose port 80 and run nginx hello world
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]