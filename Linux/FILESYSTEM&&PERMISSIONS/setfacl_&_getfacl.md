# Linux ACL Management Documentation
## getfacl and setfacl

### 1. Overview
Access Control Lists (ACLs) allow you to assign permissions to multiple specific users or groups on a file or directory. It doesn't come by default with some distros, so it has to be installed:

```sh
sudo apt install acl -y
```

ACLs are managed using:

- getfacl → view ACL permissions
- setfacl → modify ACL permissions

### 2. getfacl
getfacl displays the Access Control List (ACL) of a file or directory.

Basic Syntax: getfacl FILE_OR_DIRECTORY

```sh
getfacl vaultwarden
```
Example output:

```sh
# file: vaultwarden
# owner: root
# group: root
user::rwx
user:mustapha:rw-
group::r-x
mask::rwx
other::r-x
```

Explanation of Output
Field	Meaning
- user::	Permissions for the owner
- user:mustapha:	ACL entry for user mustapha
- group::	Permissions for the group owner
- mask::	Maximum permissions allowed for named users/groups
- other::	Permissions for everyone else

Example:
```sh
user:mustapha:rw- :
```
This means: User mustapha has:
- read
- write
- no execute

eFor directories, lack of execute means the user cannot cd into the directory.

## 3. setfacl
setfacl modifies ACL permissions on files and directories.

```sh
setfacl [options] [permissions] FILE
setfacl -m u:username:permissions file
```

### Add ACL permission for a user

```sh
setfacl -m u:mustapha:rwx vaultwarden
```

This means: Grant mustapha:

- read
- write
- execute

### Add permission for a group

```sh
setfacl -m g:developers:rwx project
```

### Remove ACL for a user
```sh
setfacl -x u:mustapha vaultwarden
```

### Remove all ACL entries
```sh
setfacl -b vaultwarden
````
Apply ACL recursively
```sh
setfacl -R -m u:mustapha:rwx vaultwarden
```
-R means recursive.

## 6. Special Permission: X

Give execute permission only if the file is a directory or already executable, also it's to note that. The capital X in setfacl is only a conditional flag used when setting permissions recursively; it applies execute permission only to directories or to files that are already executable.
```sh
setfacl -R -m u:mustapha:rwX vaultwarden
```

So basically:

- Owner (u::) → If the user is the file owner, use the owner permissions.
- Named ACL user (u:username) → If the user matches a specific ACL entry, use the ACL permissions.
- Group (g::) or ACL groups (g:groupname) → If the user is in the file’s group, use group permissions.
- Others (o::) → If none of the above match, use others permissions.
- Mask (mask::) → The mask limits the maximum allowed permissions for ACL users and groups.
