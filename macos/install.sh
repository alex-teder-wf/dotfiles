#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
vscode_user_dir="$HOME/Library/Application Support/Code/User"

mkdir -p "$vscode_user_dir"

for name in settings.json keybindings.json; do
  target="$vscode_user_dir/$name"
  source="$repo_dir/vscode/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    backup="$target.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing $name to $backup"
    mv "$target" "$backup"
  fi

  ln -sfn "$source" "$target"
  echo "Linked $target -> $source"
done
