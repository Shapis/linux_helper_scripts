#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Check if the user provided an app name to search
if [ -z "$1" ]; then
    echo -e "${RED}Usage: $0 <app_name>${NC}"
    exit 1
fi

app_name="$1"

# Function to print section headers
print_header() {
    echo -e "\n${YELLOW}Searching for '$app_name' in $1...${NC}"
}

# Search in Homebrew (brew)
print_header "Homebrew"
if brew_output=$(brew search "$app_name" 2>/dev/null); then
    if [ -n "$brew_output" ]; then
        echo "$brew_output"
    else
        echo -e "${RED}No results found in Homebrew.${NC}"
    fi
else
    echo -e "${RED}Error while searching Homebrew.${NC}"
fi

# Search in Flatpak
print_header "Flathub"
flatpak_output=$(flatpak search "$app_name" 2>&1)
if echo "$flatpak_output" | grep -qi "No matches found"; then
    echo -e "${RED}No results found in Flathub.${NC}"
else
    echo "$flatpak_output"
fi

# Search in Nala
print_header "Nala"
if nala_output=$(nala search "$app_name" 2>/dev/null); then
    if [ -n "$nala_output" ]; then
        echo "$nala_output"
    else
        echo -e "${RED}No results found in Nala.${NC}"
    fi
else
    echo -e "${RED}Error while searching Nala.${NC}"
fi

echo -e "\n${GREEN}Search completed.${NC}\n"

