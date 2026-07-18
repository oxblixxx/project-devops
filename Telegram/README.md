# GENERATE A TELEGRAM USER ID & BOT API TOKEN
To generate a Telegram User ID (the numeric ID), the easiest way is to use a bot:

1. Open Telegram.
2. Search for @userinfobot
3. Tap Start.

Then, to create a bot

## Step 1: Open BotFather

Open the official BotFather bot:

```sh
BotFather
```

Make sure it has the verified badge. BotFather is Telegram's official bot management account.

## Step 2: Start the bot

Send:

```sh
/start
```

BotFather will display a list of available commands.

## Step 3: Create a new bot

Send:

```sh
/newbot
```

BotFather will ask for:

1. Bot Name

This is the display name users will see.

Example:

Pelumi DevOps Bot
2. Bot Username

The username:

must be unique
must end with bot

Examples:

```sh
pelumi_devops_bot
PelumiHelperBot
cloudopsassistant_bot
```

If the username is already taken, BotFather will ask you to choose another one.

Step 4: Save the API Token

BotFather will reply with something like:

Done!

Use this token to access the HTTP API:

```sh
123456789:AAH2k4Lxxxxxxxxxxxxxxxxxxxx
```

Fetch that Token, that's the bot token. To get the both started and ready, engage it. 

Step 5: Start your bot

Open your bot by clicking its username or visiting:

https://t.me/<your_bot_username>

Click Start.
