## File Ownership and Groups in Linux

File ownership is a fundamental concept in Linux. It restricts or allows access to files and directories based on the user or group associated with them.

## CHOWN – Change Ownership

The chown command (short for Change Ownership) allows you to change the owner and/or group of a file or directory.

When a file is created by a logged-in user:

- The owner is set to that user
- The group is set to the user’s default group

You can change these using chown.

### Example: Change Owner and Group

```sh
mkdir file1
chown tunde:tunde file1
```
- Owner → tunde
- Group → tunde

Permissions can then be applied as required, while users without proper permissions will have limited access.

Example: Change Group Only

```sh
chown :tunde file1
```
- Owner → unchanged
- Group → tunde

Example: Change Owner Only
```sh
chown tunde file1
```
- Owner → tunde
- Group → unchanged

For more details, see [GeeksforGeeks-Chown-Guide](https://www.geeksforgeeks.org/linux-unix/chown-command-in-linux-with-examples/) and also consult  `chown --help`.

## GROUP – Organizing Users

Groups are a way to manage multiple users efficiently. Instead of assigning permissions to each user individually, you can assign permissions to a group.

### Create a Group

```sh
groupadd hr-team
```

### Delete a Group

```sh
groupdel hr-team
```
### Assign a User to a Group
Using usermod:
```sh
sudo usermod -aG <groupname> <username>
sudo usermod -aG docker tunde
```
-aG → append user to the group without removing them from existing groups

## Using gpasswd:
```sh
sudo gpasswd -a <username> <groupname>
sudo gpasswd -a tunde docker
```
### Remove a User from a Group
```sh
sudo gpasswd -d tunde docker
```

### View Users in a Group

```sh
cat /etc/passwd
```
Example output:

```sh
cicd:x:1002:buildbot,root
```

- cicd → group name
- x → group password (shadowed)
- 1002 → group ID
- buildbot, root → users in the group

## Limit SSH Access to a Group

You can restrict SSH access to specific groups:

Edit SSH configuration:

```sh
sudo nano /etc/ssh/sshd_config
```
Append this line in the conf file for groups to restrict ssh grant to:

```sh
AllowGroups cicd developer hr
```

Save and restart SSH service:

```sh
sudo systemctl restart sshd
```
