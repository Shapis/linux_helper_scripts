#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to check for errors or no updates
check_update_status() {
  if [ $? -ne 0 ]; then
    echo -e "  ${RED}✗ $1 failed.${NC}"
    exit 1
  elif echo "$2" | grep -qiE "nothing to do|already up-to-date|all packages are up to date"; then
    echo -e "  ${GREEN}✔ $1: No updates were needed.${NC}"
  else
    echo -e "  ${GREEN}✔ $1 completed successfully.${NC}"
  fi
}

# Header
echo -e "\n${BOLD}System Update Script${NC}\n"

# Prompt for sudo password upfront
# echo -e "\n${CYAN}Please enter your sudo password...${NC}"
sudo -v  # This will prompt for the sudo password without performing any actual commands

# Update Nala
echo -e "\n${CYAN}1. Updating Nala...${NC}"
if command -v nala &>/dev/null; then
  # Unfiltered output for nala update and upgrade
  sudo nala update && sudo nala upgrade -y
  check_update_status "Nala update and upgrade" "$?"
else
  echo -e "  ${YELLOW}⚠ Nala is not installed. Skipping...${NC}"
fi

# Update Flatpak
echo -e "\n${CYAN}2. Updating Flatpak...${NC}"
if command -v flatpak &>/dev/null; then
  # Unfiltered output for flatpak update
  flatpak update -y
  check_update_status "Flatpak update" "$?"
else
  echo -e "  ${YELLOW}⚠ Flatpak is not installed. Skipping...${NC}"
fi

# Update Homebrew
echo -e "\n${CYAN}3. Updating Homebrew...${NC}"
if command -v brew &>/dev/null; then
  # Capture output of `brew update` and `brew upgrade`
  brew_output=$(brew update 2>&1)
  
  # Check if Homebrew is up-to-date, suppressing redundant messages
  if echo "$brew_output" | grep -qiE "nothing to do|already up-to-date"; then
    echo -e "  ${GREEN}✔ Homebrew is already up-to-date. No updates were needed.${NC}"
  else
    brew_upgrade_output=$(brew upgrade && brew cleanup 2>&1)
    check_update_status "Homebrew update and upgrade" "$brew_upgrade_output"
  fi
else
  echo -e "  ${YELLOW}⚠ Homebrew is not installed. Skipping...${NC}"
fi

# Install/Update Firefox GNOME Theme (suppress all output)
echo -e "\n${CYAN}4. Updating Firefox GNOME Theme...${NC}"
# Unfiltered output for curl script execution
if curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash; then
  echo -e "  ${GREEN}✔ Firefox GNOME Theme updated successfully.${NC}"
else
  echo -e "  ${RED}✗ Firefox GNOME Theme updating failed.${NC}"
fi


# Update pipx
echo -e "\n${CYAN}5. Updating pipx...${NC}"
if command -v pipx &>/dev/null; then
  pipx_output=$(pipx upgrade-all 2>&1)
  check_update_status "pipx update" "$pipx_output"
else
  echo -e "  ${YELLOW}⚠ pipx is not installed. Skipping...${NC}"
fi

# Footer
echo -e "\n${GREEN}All updates completed!${NC}\n"

