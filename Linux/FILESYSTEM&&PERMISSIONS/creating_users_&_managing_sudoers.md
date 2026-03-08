## Users & Sudoers

Users are created using the `useradd` or `adduser` commands (Difference between both is one is interactive while the other isn't). It is essential to assign users to groups so that privileges can be managed from a single point of truth. 
When setting user's passwords, it’s important to configure proper attributes to enforce security policies.
 
```sh
- -i {days}       Account inactive <days> after password expires.
- -n <days>  # Minimum days before password can be changed.
-w <days>  # Warn user <days> before password expires.
-x <days>  # Maximum days before password must change.
```

### Password Policy
Configuring PAM password policy by installing & configure libpam-pwquality. PAM is how Linux handles authentication, password policies, and session management.


```sh
sudo apt install libpam-pwquality -y
```
Then edit the conf file

```sh
sudo nano /etc/pam.d/common-password
```

Find this line :

```sh
password       requisite                       pam_pwquality.so retry=3
password    [success=1 default=ignore]    pam_unix.so obscure sha512 rem
```
Replace with:

```sh
password    requisite           pam_pwquality.so retry=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1
password    [success=1 default=ignore]    pam_unix.so obscure sha512 remember=5
```

Hence, password policy is set for user password creation.

While setting users, 

### For secure authentication:
- Users should ideally login via SSH keys.
- Passwords should primarily be used for sudo authentication.
- For automated CI/CD users, NOPASSWD can be safely applied, but commands should be strictly restricted to only what is necessary.

Sudoers configuration allows fine-grained control over which commands users or groups can execute. Instead of specifying permissions per user, it is recommended to:

- Create a group sudoers file.
- Add users to that group.
- Users automatically inherit the group’s sudo permissions, simplifying management and enforcing consistent security policies.

A template for creating restricted sudoers files and examples of allowed commands for users and groups is provided [here](Linux/USER/README.md). 

TO DO: LOOK INTO PAM EXTENSIVELY
