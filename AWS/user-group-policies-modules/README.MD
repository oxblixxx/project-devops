# IAM User and Group Management Module

## Overview
This Terraform module creates:
- IAM users with encrypted credentials
- IAM groups with specified policies
- Secure access keys encrypted via Keybase PGP

## Prerequisites
- Keybase account ([keybase.io](https://keybase.io)), here is a quick video on ([keybase_quick_learn](https://www.youtube.com/watch?v=X_qmKQkUxac&pp=ygUHa2V5YmFzZQ%3D%3D))
- AWS credentials with IAM permissions WITH ADNINISTRATIVE PERMISSION

## Credential Encryption
All sensitive outputs (passwords, secret keys) are encrypted using Keybase PGP. Copy the respective output, proceed to ([keybase.io](https://keybase.io)), to decrypt the keys. The encrypted outputs should pasted on `keybase` website in this format:
```sh
-----BEGIN PGP MESSAGE-----

BASE64_ENCODED_ENCRYPTED_DATA {LEAVE A SPACE JUST AS IT IS ABOVE}
-----END PGP MESSAGE-----
```