#!/usr/bin/env bash
set -euo pipefail

# Generate a new SSH key for this machine

KEY_PATH="$HOME/.ssh/id_ed25519"
COMMENT="${USER}@$(hostname)"

if [[ -f "$KEY_PATH" ]]; then
    echo "SSH key already exists at $KEY_PATH"
    read -p "Overwrite? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

echo "Generating new ed25519 SSH key..."
echo "Comment: $COMMENT"
echo

ssh-keygen -t ed25519 -C "$COMMENT" -f "$KEY_PATH"

echo
echo "Key generated successfully!"
echo
echo "Public key:"
cat "${KEY_PATH}.pub"
echo

if command -v wl-copy &> /dev/null; then
    wl-copy < "${KEY_PATH}.pub"
    echo "Copied to clipboard!"
fi

echo "Add this key to GitHub: https://github.com/settings/ssh/new"
