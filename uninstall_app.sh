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
        return 0  # App is installed via Homebrew
    else
        return 1  # App is not installed
    fi
}

# Function to check if the app is installed via Nala
check_nala_installed() {
    if nala list --installed | grep -q "$1"; then
        return 0  # App is installed via Nala
    else
        return 1  # App is not installed
    fi
}

# Function to check if the app is installed via Flatpak
check_flatpak_installed() {
    if flatpak list --app | grep -q "$1"; then
        return 0  # App is installed via Flatpak
    else
        return 1  # App is not installed
    fi
}

# Function to uninstall using Homebrew (for macOS)
uninstall_with_brew() {
    echo -e "  ${CYAN}Uninstalling $1 using Homebrew...${NC}"
    brew uninstall "$1"
}

# Function to uninstall using Nala (for Ubuntu/Debian-based Linux distros)
uninstall_with_nala() {
    echo -e "  ${CYAN}Uninstalling $1 using Nala...${NC}"
    sudo nala purge "$1"
}

# Function to uninstall using Flatpak
uninstall_with_flatpak() {
    echo -e "  ${CYAN}Uninstalling $1 using Flatpak...${NC}"
    flatpak uninstall "$1"
}

# Function to uninstall app
uninstall_app() {
    app_name="$1"
    options=()  # Array to hold available options
    choices=()  # Array to hold the exact names of the packages
    installed_managers=()  # To track which package managers already have the app installed

    # Check if the app is already installed in any package manager and add them to installed_managers
    if check_brew_installed "$app_name"; then
        installed_managers+=("Homebrew")
    fi
    if check_nala_installed "$app_name"; then
        installed_managers+=("Nala")
    fi
    if check_flatpak_installed "$app_name"; then
        installed_managers+=("Flatpak")
    fi

    # If the app is already installed in one or more package managers, show where it is installed
    if [ ${#installed_managers[@]} -gt 0 ]; then
        echo -e "  ${GREEN}$app_name is installed via ${installed_managers[*]}.${NC}"
    else
        echo -e "  ${RED}$app_name is not installed in any of the supported package managers.${NC}"
        exit 1
    fi

    # Ask the user if they want to proceed with uninstallation
    echo -e -n "  ${YELLOW}Do you want to uninstall $app_name? (y/n): ${NC}"
    read -p "" choice

    if [[ "$choice" =~ ^[Yy]$ ]]; then
        # Uninstall from each package manager that has the app installed
        for manager in "${installed_managers[@]}"; do
            case $manager in
                "Homebrew")
                    uninstall_with_brew "$app_name"
                    ;;
                "Nala")
                    uninstall_with_nala "$app_name"
                    ;;
                "Flatpak")
                    uninstall_with_flatpak "$app_name"
                    ;;
                *)
                    echo -e "  ${RED}✗ Unknown package manager: $manager.${NC}"
                    ;;
            esac
        done
    else
        echo -e "  ${GREEN}No changes made. $app_name was not uninstalled.${NC}"
    fi
}

# Check if the user provided an app name
if [ -z "$1" ]; then
    echo -e "  ${YELLOW}⚠ Usage: $0 <app_name>${NC}"
    exit 1
fi

# Uninstall the requested app
uninstall_app "$1"

