🔐 Bitwarden CLI Setup for Vaultwarden
This guide walks you through installing the Bitwarden Command Line Interface (bw CLI) and configuring it to connect with your self-hosted Vaultwarden server using API keys.
- Step 1: Install the Bitwarden CLI
  - Ensure Node.js is installed on your server. You will use npm (Node Package Manager) to install the CLI globally.
  - Install necessary build tools
```sh
sudo apt update
sudo apt install build-essential -y
```
  - Install the Bitwarden CLI
```sh
npm install -g @bitwarden/cli
```
- Step 2: Retrieve Vaultwarden API Keys
You need a Client ID and Client Secret from your Vaultwarden user profile to use the API key login method. Log in to your Vaultwarden Web Vault console.
Click on your user avatar (top right).Go to Account Settings > Security > API Key. Click View API Key and copy both the Client ID and Client Secret.

- Step 3: Configure Environment Variables. Export the retrieved API keys as environment variables. Replace the placeholders with your actual keys.

```sh
export BW_CLIENTID="YOUR-CLIENT-ID"
export BW_CLIENTSECRET="YOUR-CLIENT-SECRET"
```

- Step 4: Configure the Server URL
Tell the CLI to connect to your Vaultwarden instance instead of the official Bitwarden servers. Replace https://xxxxxxx.com with your full Vaultwarden domain.

```sh
bw config server https://xxxxxxx.com
```
- Step 5: Log In to the CLIUse the --apikey flag to authenticate using the environment variables set in Step 3.
```sh
bw login --apikey
```
Upon success, the CLI is configured and ready to use!
