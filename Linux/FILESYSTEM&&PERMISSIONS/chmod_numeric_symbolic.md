# Linux File Permissions (CHMOD)
File permissions in Linux are essential for system security and access control. They determine what level of access a user has to a file or directory.

Linux permissions control three main actions:

- r (read) = 4
- w (write) = 2
- x (execute) = 1

The sum of these values determines the numeric (octal) permission.

For example:

- 7 = 4 + 2 + 1 = rwx
- 6 = 4 + 2 = rw-
- 5 = 4 + 1 = r-x
- 4 = r--

## Users in Linux

On a Linux system, when a user is created:

A group with the same name is also created.

Every file and directory has three ownership categories:

- User (u) – The file owner
- Group (g) – The group owner
- Others (o) – All other users

## Understanding Permission Structure

Example:

```sh
drwxr-xr-x 11 root root 4096 Jan 4 17:33 wazuh-docker
```
The permission section:

```sh
drwxr-xr-x
```

It contains 10 characters:

```sh
d | rwx | r-x | r-x
```

### Breakdown

First character (d) → File type

- d = directory

- = regular file

- l = symbolic link

- Next 3 characters (rwx) → User (Owner) permissions

- Next 3 characters (r-x) → Group permissions

- Last 3 characters (r-x) → Others permissions

### Numeric Interpretation

- User: rwx = 7

- Group: r-x = 5

- Others: r-x = 5

So the numeric representation is:

```sh
755
```

Each category can range from `000 → 777`

## Changing Permissions with chmod

chmod means change mode.

Basic syntax:

- chmod <permission> <filename>

## Example 1: Using Numeric Mode

```sh
mkdir wazuh-docs
ls -ld wazuh-docs
drwxr-xr-x 2 root root 4096 Mar 1 15:12 wazuh-docs/
chmod 777 wazuh-docs
```


Now:
```sh
drwxrwxrwx
```
This gives full permissions (read, write, execute) to:

- User
- Group
- Others

## Example 2: Using Symbolic Mode

Instead of numeric mode:

- chmod go+w wazuh-docs

- g = group

- o = others

- +w = add write permission

## Removing Execute Permission
Numeric:

```sh
chmod 666 wazuh-docs
```
Symbolic:
```sh
chmod ugo-x wazuh-docs
```
- u = user
- g = group
- o = others
-x = remove execute

Result:

```sh
drw-rw-rw-
```
Recursive Permission Changes

To apply changes recursively:

```sh
chmod -R 755 directory_name
```

The -R flag applies permission changes to all files and subdirectories.

## Special Permissions

Linux has three special permissions:

- setuid
- setgid
- sticky bit

1. setuid (Set User ID)

Applies only to files

When executed, the file runs with the owner’s permissions, not the user running it.

Example:
If a file owned by root has setuid enabled, it runs with root privileges.

Numeric value: 4

Example:

```sh
chmod 4755 filename
```
Symbolic:

```sh
chmod u+s filename
```

2. setgid (Set Group ID)
On Files:

The file runs with the group’s permissions.

On Directories:

New files created inside inherit the parent directory’s group ownership.

Numeric value: 2

Example:

```sh
chmod 2755 directory_name
```

Symbolic:

```sh
chmod g+s directory_name
```

3. Sticky Bit

Used mainly in shared directories (e.g., /tmp).

Users can delete only their own files

Even if others have write permission

Numeric value: 1

Example:

```sh
chmod 1777 shared_directory
```

Symbolic:

```sh
chmod +t shared_directory
```

## Understanding umask

umask stands for:

User file-creation mode mask

It defines which permissions are removed (masked) from newly created files and directories.

Default Creation Permissions

By default:

- New directories → 777
- New files → 666

The umask subtracts permissions from these defaults.

Common umask Values
0022 (Common Default)
777 - 022 = 755  (directory)
666 - 022 = 644  (file)

Result:

Directories → rwxr-xr-x

Files → rw-r--r--

0002 (Common in Shared Environments)
777 - 002 = 775
666 - 002 = 664

Used when users share a common group.

Important Note

By default:

Files do not get execute permission automatically.

Execute permission must be added manually:

chmod +x script.sh
