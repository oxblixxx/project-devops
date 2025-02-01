# Authentik Installation and Setup Guide

## Prerequisites
Ensure the following prerequisites are met before starting the installation:
- Docker and Docker Compose are installed.
- Access to the terminal with appropriate privileges.
- Domain and DNS properly configured to point to your server.
- Traefik reverse proxy running.

## Installation Steps

### 1. Verify Environment Variables
1. Open the `.env` file and ensure that the `UID` and `GID` of the user running the compose file are set correctly.
   - Use the following command to check the user's UID and GID:
     ```bash
     cat /etc/passwd
     ```
2. Ensure all variables in the `.env` file are correctly set to their corresponding values.
3. To generate a strong password, use the following command:
     ```bash
     openssl rand -base64 16
     ```
4. Ensure that the Docker network used by Traefik matches the network where the `authentik_server` is configured.

### 2. Adjust Permissions and Run Docker Compose
1. Open a terminal as the same user whose `UID` and `GID` are specified in the `.env` file.
2. Run the following command to start the Docker Compose process:
   ```bash
   docker compose up
   ```
3. In a second terminal, adjust the permissions for the `appdata` directory:
   ```bash
   sudo chown user:user -R appdata/
   ```
   Replace `user:user` with the correct username and group.
> **Note:** The reason for opening a new terminal and changing the ownership of the files is that the directory is initially owned by the root user after running the compose file. Alternatively, you can create the volume path manually before running the Docker Compose file to avoid this step.
4. Allow the Docker Compose process to continue until it throws an error related to Redis.
5. Cancel the running Docker Compose process (e.g., by pressing `Ctrl+C`).

### 3. Force Recreate Docker Containers
1. Run the following command to recreate the containers:
   ```bash
   sudo docker compose up -d --force-recreate
   ```

### 4. Perform Initial Setup
1. Access the setup URL in your browser:
   ```
   https://authentiik.oxlava.me/if/flow/initial-setup/
   ```
2. Complete the initial setup wizard to configure the first-time user. For detailed installation instructions, refer to the official [Authentik documentation](https://docs.goauthentik.io/docs/install-config/install/docker-compose).


### 5. Secure the Admin Account
1. Log in to the Authentik Admin Interface.
2. Navigate to:
   - `Admin Interface >> Directory >> Users`
3. Create a new admin user:
   - Follow the prompt to create a user.
   - Scroll down to set a password for the new user.

### 6. Add the User to the Admin Group
1. Navigate to:
   - `Groups >> Authentik-admins >> Users`
2. Add the newly created user to the admin group:
   - Click on `Add Existing Users`.
   - Select the user and click `+` to add them to the group.
3. Delete or deactivate the default `akadmin` user for security purposes.

### 7. Authentik Setup with Traefik Reverse Proxy
Now that Authentik is set up, it can be managed using [different approaches](https://docs.goauthentik.io/docs/providers). In simpler terms, Authentik can protect applications behind different domains. In this setup, Traefik is used as the reverse proxy, and SAML/OIDC will be used as test in this documentation to utilize to verify access outside the domain.
Since Authentik is behind Traefik, protecting a designated URL is straightforward:

1. Add a single line of Traefik label to your configuration.
```sh
  - "traefik.http.routers.<service-entrypoints-name>.middlewares=authentik@file"
```
3. Create an application and provider in Authentik.

Once these steps are completed, the designated URL will be protected by Authentik.

Already, while spinning up Traefik, Authentik as been added in the [dynamic folder](https://github.com/oxblixxx/project-devops/blob/main/Traefik/dynamic/authentik.yaml), to setup the Authentik middlewares. You can go ahead to uncomment that in that line, and it's not needed to restart the docker container.

### 8. Securing Applications
Securing an application behind the Traefik reverse proxy is simply just to add a singe line like we mentioned
```sh
  - "traefik.http.routers.<service-entrypoints-name>.middlewares=authentik@file"
```
If you have existing labels in your application compose file, ensure your middleware name matches the entrypoints you want to secure, such as `grafana-web` and `grafana-secure`.  `grafana-secure` is what we will want to secure as it runs on HTTPS.  
```sh
      - "traefik.http.routers.grafana-web.entrypoints=web"
      - "traefik.http.routers.grafana-secure.entrypoints=websecure"
      - "traefik.http.routers.grafana-secure.middlewares=authentik@file"
```

If you restart the service and access the it on the URL, you should get something similar to this
<IMG>

---

## 9. Create a Proxy Provider

1. Log in to the **Authentik Admin Console** as an admin user and access the **Admin Interface**.
2. Navigate to **Applications >> Providers** and create a new provider.
3. Choose **Proxy Provider** and configure the following:
   - **Name**: Provide a name for the provider.
   - **Authentication Flow**: Set to `None`.
   - **Authorization Flow**: Choose an appropriate flow.
4. Select **Forward Auth Single Application**.
5. Set **External Host** to `https://www.<service-name>.com`.
6. Leave the remaining settings as default and click **Finish**.

---

## 10. Create an Application

1. Navigate to **Applications** and create a new application.
2. Configure the following:
   - **Name**: Set a name for the application.
   - **Slug**: Use the same value as the name.
   - **Provider**: Select the provider created earlier.
   - **Groups**: Leave this as is.
3. Under **UI Settings**, set the **Launch URL** to the value used for **External Host**.
4. Click **Create**.

---

## 11. Configure Outpost

1. Navigate to **Outpost** and edit the `Authentik Embedded Outpost`.
2. Under **Available Applications**, locate the newly created application.
3. Click on the application, then click the `>` sign to move it to **Selected Applications**.
4. Click **Update** to save the changes.

---

## 12. Verify Configuration

1. Refresh the **External Host** you want Authentik to protect.
2. You should now be redirected to Authentik for authentication before accessing the application.

---

We have succesfully been able to use Authentik with applications behind Traefik, To setup application not behind Traefik, [Authentik](https://docs.goauthentik.io/integrations/] has provided with the approach to be taken. We will be setting up for [GITLAB](https://docs.goauthentik.io/integrations/services/gitlab/) . It's to be noted that the GITLAB is outside the Traefik domain. I did it once and got it once, so I believe that part of the docs is self explanatory.


### Rebranding Authentik
---

## Step 1: Prepare Logo and Favicon

1. Obtain your logo images and favicon.
2. Transfer them to the server using a tool like **FileZilla** or add them to this repository.
3. If using a repository, clone it and move the files to the appropriate folder:
   - **Folder Path**: `authentik/media/public` (this is the mounted volume for Authentik data).

---

## Step 2: Update Branding in Admin Interface

1. Log in to the **Authentik Admin Console** and access the **Admin Interface**.
2. Navigate to **System > Brands**.
3. Update the following fields:
   - **Logo**: Provide the path to your logo file.
   - **Favicon**: Provide the path to your favicon file.
4. Save the changes.
5. Logout.

---

## Setting up Enrolment

## Setting up 2FA

## Notes
- Always ensure permissions are correctly set to avoid permission errors.
- After the setup, review and secure the configurations according to your organization's policies.

For additional support, refer to the [Authentik Documentation](https://docs.goauthentik.io/).
