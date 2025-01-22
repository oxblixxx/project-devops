Firstly look at the .env file, ensure that the user running the compose file, there `UID` and `GID` is set properly. with `cat /etc/passwd`.
Afterwards, open a new terminal of the same user, run the compose file, on the second terminal set permsisions `sudo chown user:user -R appdata/`.
Then proceed to let the compose to run till it pops and error related to redis, cancel the compose.
Then run `sudo docker compose up -d --force-recreate`.
https://docs.goauthentik.io/docs/install-config/install/docker-compose
Then, proceed to the url of the setup `https://authentiik.oxlava.me/if/flow/initial-setup/`.
Set up the first time user.
Afterwards proceed to delete the akadmin, user, better still deactivate the user.
Create a new user firstly and add the user admin group.
Click on Admin interface  >> Directory >> Users. Follow the prompt to Create an admin user.
Then click on the users, scroll down to set password for the user.
To add the created user to sudo group, click on groups on the left dashboard,
Groups >> Authentik-admins >> Users >> Add existing Users >> + >> Then add the existing user.
