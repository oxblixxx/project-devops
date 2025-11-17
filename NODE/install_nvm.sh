#!/bin/bash

BASHRC="$HOME/.bashrc"

# Step 1: record initial state
if [ -f "$BASHRC" ]; then
    OLD_CHECKSUM=$(sha256sum "$BASHRC" | awk '{print $1}')
else
    OLD_CHECKSUM="NOFILE"
fi

# Step 2: run NVM installer
# FETCH LATEST VERSION FROM HERE, visit the link, then change `v0.40.3` from the curl command to the latest release
#   |   |    |
#   V   v    v
# https://github.com/nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Step 3: record new state
if [ -f "$BASHRC" ]; then
    NEW_CHECKSUM=$(sha256sum "$BASHRC" | awk '{print $1}')
else
    NEW_CHECKSUM="NOFILE"
fi

# Step 4: compare and act
if [ "$OLD_CHECKSUM" != "$NEW_CHECKSUM" ]; then
    echo "Detected changes in ~/.bashrc — sourcing file..."
    source "$BASHRC"
else
    echo "No changes detected — loading NVM manually..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Step 5: print NVM version
nvm -v
