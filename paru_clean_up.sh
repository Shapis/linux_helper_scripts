#!/bin/bash

paru -Sc --noconfirm

echo -e

clone_dir="$HOME/.cache/paru/clone"

echo "🧹 Searching for unused AUR clone folders in: $clone_dir"

if [[ ! -d "$clone_dir" ]]; then
  echo "✅ Nothing to clean. Clone directory doesn't exist."
  exit 0
fi

installed_aur=$(paru -Qm | cut -d' ' -f1 | sort)
cloned_pkgs=$(ls "$clone_dir" 2>/dev/null | sort)
unused_pkgs=$(comm -23 <(echo "$cloned_pkgs") <(echo "$installed_aur"))

if [[ -z "$unused_pkgs" ]]; then
  echo "✅ No unused clone folders found."
  exit 0
fi

echo "🗑️ Removing the following unused clone folders:"
echo "$unused_pkgs"
echo

while IFS= read -r pkg; do
  path="$clone_dir/$pkg"
  rm -rf "$path"
  echo "🧹 Removed: $path"
done <<< "$unused_pkgs"

echo "✅ Done cleaning."

