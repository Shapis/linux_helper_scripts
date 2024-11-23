#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No color

# Check if the user provided an app name to search
if [ -z "$1" ]; then
    echo -e "${RED}Usage: $0 <app_name>${NC}"
    exit 1
fi

app_name="$1"

# Function to print section headers
print_header() {
    echo -e "\n${CYAN}Searching for '$app_name' in $1...${NC}"
}

# Search in Homebrew (brew)
print_header "Homebrew"
brew search "$app_name" 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Error while searching Homebrew.${NC}"
fi

# Search in Flatpak
print_header "Flathub"
flatpak search "$app_name" 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Error while searching Flathub.${NC}"
fi

# Search in Nala
print_header "Nala"
nala search "$app_name" 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Error while searching Nala.${NC}"
fi

echo -e "\n${GREEN}Search completed.${NC}"

