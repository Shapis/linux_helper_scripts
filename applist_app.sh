#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No color

# Function to list installed apps via Nala (APT wrapper)
list_nala_apps() {
    echo -e "\n${CYAN}Listing apps installed with Nala...${NC}"
    if command -v nala &> /dev/null; then
        # Unfiltered output for nala list
        nala list --nala-installed
    else
        echo -e "  ${YELLOW}⚠ Nala is not installed. Skipping...${NC}"
    fi
}

# Function to list installed apps via Brew
list_brew_apps() {
    echo -e "\n${CYAN}Listing apps installed with Brew...${NC}"
    if command -v brew &> /dev/null; then
        # Unfiltered output for brew leaves, --installed-on-request might be needed.
        brew leaves 
    else
        echo -e "  ${YELLOW}⚠ Homebrew is not installed. Skipping...${NC}"
    fi
}

# Function to list installed apps via Flatpak
list_flatpak_apps() {
    echo -e "\n${CYAN}Listing apps installed with Flatpak...${NC}"
    if command -v flatpak &> /dev/null; then
        # Unfiltered output for flatpak list
        flatpak list --app
    else
        echo -e "  ${YELLOW}⚠ Flatpak is not installed. Skipping...${NC}"
    fi
}

# Main script execution

list_nala_apps
list_brew_apps
list_flatpak_apps

echo -e "\n${GREEN}All done!${NC}\n"

