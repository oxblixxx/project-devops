## Traefik Configuration with Cloudflare DNS

This guide details the steps to configure Traefik for SSL termination using Cloudflare DNS.

**Prerequisites**

* Cloudflare account with your domain added

**Steps**

1. **DNS record setup in Cloudflare**

   * Log in to your Cloudflare account.
   * Navigate to the DNS settings for your domain.
   * Create an A record with the following details:
      * Name: `@` (root domain)
      * Content: The public IP address provided by your ISP/Cloud Provider
   * For all subdomains, create a CNAME record with the following details:
      * Name: `<subdomain name>` (e.g., `www`, `mail`)
      * Content: `@` (root domain)

2. **Enable Full SSL in Cloudflare**

   * Navigate to the SSL/TLS settings for your domain in Cloudflare.
   * Set the SSL/TLS encryption mode to **Full**.
  
3. **Create API token**
   * Click on the Avatar icon, navigate to my profile, API tokens, 
   * Permissions, zone  zone
   * 
**Traefik Configuration**

1. **Permissions**
Navigate to the config file to change the permission of the `acme.json` file.

   ```bash
   sudo chmod 600 acme.json
   ```
Before the setup of this setup, it is to be noted that DNS is been handled by cloudflare, create a A record with the public address provided by ISP/CLOUD PROVIDER as the root domain. Then for all subdomains, create a cname record. Also cloudflare requires a security setting to be put in place, navigate to SSL/TLS, then configure the SSL/TLS encryption mode to be full. It also to be noted that while traefik handles ssl termination as well, Cloudflare has a ssl provided to us, when we choose to generate a ssl certificate for our domain with ssl, cloudflare will have the certificate set has backup SSL. Also  quite somethings are to be changed, starting from the acme.json file in the config directory should be modified with sudo chmod 600 acme.json. WHich the docker network should be created using sudo docker network create traefik, afterwards the .env file should be viewed and the respecting values should be set correctly. To get the CF_DNS_API_TOKEN, this will be done from cloudflare, okay? 
