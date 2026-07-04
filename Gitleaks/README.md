# Setting Up Gitleaks for Local Secret Scanning

This guide walks through installing the required dependencies, building Gitleaks from source, configuring it as a pre-commit hook, and running scans against your local source code.

## Prerequisites

Before building Gitleaks, ensure the following tools are installed:

* Git
* Go
* Make

---

# 1. Install Make

Update your package index and install `make`:

```bash
sudo apt update
sudo apt install -y make
```

Verify the installation:

```bash
make --version
```

---

# 2. Install Go

Install Go using your package manager:

```bash
sudo apt update
sudo apt install -y golang-go
```

Verify the installation:

```bash
go version
```

Example output:

```text
go version go1.24.x linux/amd64
```

---

# 3. Clone the Gitleaks Repository

```bash
git clone https://github.com/gitleaks/gitleaks.git
cd gitleaks
```

---

# 4. Build Gitleaks

Build the project from source:

```bash
make build
```

This command:

* Formats the Go code
* Downloads project dependencies
* Compiles the Gitleaks binary

---

# 5. Install the Binary

Copy the compiled binary into your system path:

```bash
sudo cp ./gitleaks /usr/local/bin/
```

Grant execute permissions:

```bash
sudo chmod 755 /usr/local/bin/gitleaks
```

Verify the installation:

```bash
gitleaks version
```

---

# 6. Verify the Installation

Display the available commands:

```bash
gitleaks --help
```

---

# Running Gitleaks

## Scan the Current Source Code

To scan only the files currently present in your working directory:

```bash
gitleaks dir .
```

This scans the directory contents without inspecting Git history.

---

## Scan a Specific Directory

```bash
gitleaks dir /path/to/project
```

---

## Generate a JSON Report

```bash
gitleaks dir . \
    --report-format json \
    --report-path report.json
```

---

## Generate a SARIF Report

```bash
gitleaks dir . \
    --report-format sarif \
    --report-path report.sarif
```

---

## Scan Git History

To scan commits and repository history:

```bash
gitleaks git .
```

---

# Setting Up Pre-Commit

Install the Python `pre-commit` framework.

Ubuntu/Debian:

```bash
sudo apt install -y python3-pip
pip3 install --user pre-commit
```

or

```bash
python3 -m pip install --user pre-commit
```

Verify the installation:

```bash
pre-commit --version
```

---

## Create a `.pre-commit-config.yaml`

Create a file named `.pre-commit-config.yaml` in the root of your repository:

```yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.28.0
    hooks:
      - id: gitleaks
```

> Replace the version with the version you want to use if necessary.

---

## Install the Git Hooks

From the root of your repository:

```bash
pre-commit install
```

This installs the Git pre-commit hook so that Gitleaks runs automatically before every commit.

---

## Run Against All Files

To scan the entire repository without creating a commit:

```bash
pre-commit run --all-files
```

---

## Run Only the Gitleaks Hook

```bash
pre-commit run gitleaks --all-files
```

---

# Checking the Current Working Directory

Display your current directory:

```bash
pwd
```

List the files in the current directory:

```bash
ls
```

Display detailed information:

```bash
ls -la
```

Confirm that you are inside a Git repository:

```bash
git status
```

Display the repository root directory:

```bash
git rev-parse --show-toplevel
```

---

# Updating Gitleaks

According to gitleaks, there won't be any future update, just security patches, new project is [betterleaks](https://github.com/betterleaks/betterleaks)

Navigate to the cloned repository:

```bash
cd ~/gitleaks
git pull
make build
sudo cp ./gitleaks /usr/local/bin/
sudo chmod 755 /usr/local/bin/gitleaks
```

Verify the updated version:

```bash
gitleaks version
```

---

# Common Commands

| Task                       | Command                               |
| -------------------------- | ------------------------------------- |
| Check Go version           | `go version`                          |
| Check Make version         | `make --version`                      |
| Check Gitleaks version     | `gitleaks version`                    |
| Display Gitleaks help      | `gitleaks --help`                     |
| Scan current source code   | `gitleaks dir .`                      |
| Scan Git history           | `gitleaks git .`                      |
| Run all pre-commit hooks   | `pre-commit run --all-files`          |
| Run only the Gitleaks hook | `pre-commit run gitleaks --all-files` |
| Install Git hooks          | `pre-commit install`                  |
| Show current directory     | `pwd`                                 |
| List files                 | `ls -la`                              |
| Show Git repository status | `git status`                          |
