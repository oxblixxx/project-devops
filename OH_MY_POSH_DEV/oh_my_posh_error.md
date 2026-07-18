# Troubleshooting Oh My Posh "Permission denied" in Git Bash on Windows

## Problem

After installing **Oh My Posh** with WinGet, initializing it in Git Bash and Powershell failed with:

```bash
eval "$(oh-my-posh init bash)"
```

Result:

```text
bash: /c/Users/<username>/AppData/Local/Microsoft/WindowsApps/oh-my-posh: Permission denied
```

Running:

```bash
which oh-my-posh
```

returned:

```text
/c/Users/<username>/AppData/Local/Microsoft/WindowsApps/oh-my-posh
```

---

# Root Cause

The WinGet installation installed the **MSIX (App Installer)** version of Oh My Posh.

Instead of exposing a standard executable, Windows placed an **App Execution Alias** in:

```text
C:\Users\<username>\AppData\Local\Microsoft\WindowsApps\
```

Git Bash resolved this alias when executing `oh-my-posh`.

Although the alias works correctly in **PowerShell and Gitbash**, Git Bash and powershell (MSYS2) cannot execute the Windows App Execution Alias and returns:

```text
Permission denied
```

---

# Investigation Process

### 1. Verify what Git Bash resolves

```bash
which oh-my-posh

type -a oh-my-posh
```

Output:

```text
/c/Users/<username>/AppData/Local/Microsoft/WindowsApps/oh-my-posh
```

---

### 2. Verify what PowerShell resolves

```powershell
Get-Command oh-my-posh

where.exe oh-my-posh
```

Output:

```text
C:\Users\<username>\AppData\Local\Microsoft\WindowsApps\oh-my-posh.exe
```

Notice:

```text
Version : 0.0.0.0
```

This indicates PowerShell is resolving the execution alias instead of a normal executable.

---

### 3. Confirm installation

```powershell
winget list | findstr /i "oh-my-posh"
```
# Resolution

Instead of using the MSIX/App Installer version, install or use the **standalone executable** in a normal directory.

1. Create a directory for the standalone executable

```sh
New-Item -ItemType Directory -Force -Path "C:\Tools\oh-my-posh"
```

2. Download the standalone executable from GitHub

Download the latest Windows AMD64 executable directly from the official GitHub releases page.

Alternatively, download it using PowerShell:

```powershell
Invoke-WebRequest `
  -Uri "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-windows-amd64.exe" `
  -OutFile "C:\Tools\oh-my-posh\oh-my-posh.exe"
```

Verify the download:

```powershell
& "C:\Tools\oh-my-posh\oh-my-posh.exe" version
```

Example output:

```powershell
29.32.0
```

4. Configure Git Bash to use the standalone executable

Add the installation directory to the Git Bash PATH:

```sh
export PATH="/c/Tools/oh-my-posh:$PATH"
```

Verify:

```sh
which oh-my-posh
```

Expected:

```sh
/c/Tools/oh-my-posh/oh-my-posh.exe
```

Initialize Oh My Posh:

```sh
eval "$(oh-my-posh init bash)"
```

Example:


```text
C:\Tools\oh-my-posh\oh-my-posh.exe
```
---

# PERSITING OH-MY-POHS
Open `.bashrc`, in bash and add below.

```sh
export PATH="/c/Tools/oh-my-posh:$PATH"
```

# FONTS
For fonts, I proceed to Windows Terminal settings, choose the profile > appearance > `Enabled "show all font"` > Then I choosed preferred fonts.


# CUSTOMIZE
I ran this command to customize, I firstly saved a [json-theme](https://ohmyposh.dev/docs/themes) contents to a file.

```sh
oh-my-posh init bash --config 'C:/Users/DELL/OneDrive/Documents/NOTEPAD++/peru.json'
eval "$(oh-my-posh init bash --config 'C:/Users/DELL/OneDrive/Documents/NOTEPAD++/peru.json')
```

Then I update `~/.bashrc` with the below content

```sh
eval "$(oh-my-posh init bash --config 'C:/Users/DELL/OneDrive/Documents/NOTEPAD++/peru.json')"
```

## ISSUES
* The Oh My Posh installation itself was not corrupted.
* The issue was not related to PATH permissions.
* The issue was not caused by Git Bash configuration.
* The root cause was the incompatibility between **Git Bash (MSYS2)** and the **MSIX/App Installer packaging model** used by the WinGet installation.
