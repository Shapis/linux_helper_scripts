#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to check if the app is installed via Homebrew
check_brew_installed() {
    if brew list "$1" &>/dev/null; then
        return 0  # App is already installed
    else
        return 1  # App is not installed
    fi
}

# Function to check if the app is installed via Nala
check_nala_installed() {
    if nala list --installed | grep -q "$1"; then
        return 0  # App is already installed
    else
        return 1  # App is not installed
    fi
}

# Function to check if the app is installed via Flatpak
check_flatpak_installed() {
    if flatpak list --app | grep -q "$1"; then
        return 0  # App is already installed
    else
        return 1  # App is not installed
    fi
}

# Function to check if the app exists in Homebrew and return the exact name
check_brew() {
    brew_search=$(brew search "$1" | grep -i "$1" | head -n 1)
    if [ -n "$brew_search" ]; then
        return 0  # App found
    else
        return 1  # App not found
    fi
}

# Function to check if the app exists in Nala and return the exact name
check_nala() {
    nala_search=$(nala search "$1" | grep -i "$1" | awk 'NR==1{print $1}')
    if [ -n "$nala_search" ]; then
        return 0  # App found
    else
        return 1  # App not found
    fi
}

# Function to check if the app exists in Flatpak and return the exact name
check_flatpak() {
    flatpak_search=$(flatpak search "$1" | grep -i "$1" | awk 'NR==1{print $1}')
    if [ -n "$flatpak_search" ]; then
        return 0  # App found
    else
        return 1  # App not found
    fi
}

# Function to install using Homebrew (for macOS)
install_with_brew() {
    echo -e "  ${CYAN}Installing $1 using Homebrew...${NC}"
    brew install "$1"
}

# Function to install using Nala (for Ubuntu/Debian-based Linux distros)
install_with_nala() {
    echo -e "  ${CYAN}Installing $1 using Nala...${NC}"
    sudo nala update && sudo nala install "$1"
}

# Function to install using Flatpak
install_with_flatpak() {
    echo -e "  ${CYAN}Installing $1 using Flatpak...${NC}"
    flatpak install flathub "$1"
}

# Function to install app
install_app() {
    app_name="$1"
    options=()  # Array to hold available options
    choices=()  # Array to hold the exact names of the packages

    # Check if the app is already installed in any package manager
    if check_brew_installed "$app_name" || check_nala_installed "$app_name" || check_flatpak_installed "$app_name"; then
        echo -e "  ${GREEN}$app_name is already installed. No further action required.${NC}"
        exit 0
    fi

    # Check for app in each package manager and add to options if found
    if check_brew "$app_name"; then
        options+=("Homebrew")
        choices+=("$brew_search")
    fi
    if check_nala "$app_name"; then
        options+=("Nala")
        choices+=("$nala_search")
    fi
    if check_flatpak "$app_name"; then
        options+=("Flatpak")
        choices+=("$flatpak_search")
    fi

    # If no options are found, notify the user and exit
    if [ ${#options[@]} -eq 0 ]; then
        echo -e "  ${RED}$app_name not found in any of the supported package managers.${NC}"
        exit 1
    fi

    # Only show the available options without redundant output
    echo -e "  ${CYAN}Multiple options available to install $app_name:${NC}"
    all_options=("Homebrew" "Nala" "Flatpak")
    all_choices=("$brew_search" "$nala_search" "$flatpak_search")
    for i in "${!all_options[@]}"; do
        if [ -n "${all_choices[$i]}" ]; then
            echo -e "  $((i+1))) ${all_options[$i]}: ${GREEN}${all_choices[$i]}${NC}"
        else
            echo -e "  $((i+1))) ${all_options[$i]}: ${YELLOW}Not found${NC}"
        fi
    done

    # Prompt the user to choose a number based on available options
    read -p "Please select the package manager by number (1-3): " choice

    # Ensure the choice is valid and install the app using the selected package manager
    case $choice in
        1) [ -n "$brew_search" ] && install_with_brew "$brew_search" || echo -e "  ${RED}✗ Homebrew option is unavailable.${NC}";;
        2) [ -n "$nala_search" ] && install_with_nala "$nala_search" || echo -e "  ${RED}✗ Nala option is unavailable.${NC}";;
        3) [ -n "$flatpak_search" ] && install_with_flatpak "$flatpak_search" || echo -e "  ${RED}✗ Flatpak option is unavailable.${NC}";;
        *) echo -e "  ${RED}✗ Invalid choice. Please select a valid option.${NC}"; exit 1 ;;
    esac
}

# Check if the user provided an app name
if [ -z "$1" ]; then
    echo -e "  ${YELLOW}⚠ Usage: $0 <app_name>${NC}"
    exit 1
fi

# Install the requested app
install_app "$1"

