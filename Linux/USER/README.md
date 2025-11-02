Setting Permissions for user, navigate to `/etc/sudoers.d`, create a file named as the respective user. The user will be restricted.

```
# Allow cicd to run specific commands without password
cicd_user ALL=(ALL) NOPASSWD: /bin/systemctl, /usr/bin/pm2, /usr/bin/git, /usr/bin/npm, /usr/bin/yarn, /bin/bash, /bin/chown, /bin/mkdir, /bin/chmod, /usr/local/bin/pm2, /usr/bin/env

# Deny any shell or privilege escalation
cicd_user ALL=(ALL) !/bin/su, !/usr/bin/su, !/usr/bin/bash, !/usr/bin/visudo, !/usr/bin/nano, !/usr/bin/vim, !/usr/bin/vi
```
