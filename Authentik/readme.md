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

## Notes
- Always ensure permissions are correctly set to avoid permission errors.
- After the setup, review and secure the configurations according to your organization's policies.

For additional support, refer to the [Authentik Documentation](https://docs.goauthentik.io/).
