
#!/bin/bash
#
# install.sh - A script to set up a fresh Arch Linux system after a base install.
#
# This script is designed to be run by a regular user with sudo privileges.
# It automates:
#   - Installation of an AUR helper (paru).
#   - Enabling the multilib repository.
#   - Installation of all packages listed in pkglist.txt.
#   - Symlinking of dotfiles using GNU Stow.
#   - Enabling essential systemd services.
#
# PREREQUISITES:
#   - A base Arch Linux installation is complete.
#   - The user running this script has sudo privileges.
#   - An active internet connection.
#   - The dotfiles repository has been cloned to the user's home directory.
#
################################################################################

# Exit immediately if a command exits with a non-zero status.
set -e

# --- SCRIPT START ---
echo "##################################################"
echo "###      STARTING ARCH POST-INSTALL SETUP      ###"
echo "##################################################"
echo
echo "This script will now configure your system. You will be prompted for your"
echo "sudo password once at the beginning."
echo

# Ask for the sudo password upfront
sudo -v

# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


#---------------------------------------------------------------------
# 1. INSTALL AUR HELPER (PARU)
#---------------------------------------------------------------------
echo "-> [1/6] Installing AUR Helper (paru)..."
# We need base-devel and git to build packages.
sudo pacman -S --noconfirm --needed base-devel git
# Clone and build paru if it's not already installed
if ! command -v paru &> /dev/null; then
    git clone https://aur.archlinux.org/paru.git ~/paru
    (cd ~/paru && makepkg -si --noconfirm)
    # Clean up the build directory
    rm -rf ~/paru
else
    echo "   paru is already installed. Skipping."
fi
echo


#---------------------------------------------------------------------
# 2. ENABLE MULTILIB REPOSITORY
#---------------------------------------------------------------------
echo "-> [2/6] Enabling the [multilib] repository..."
sudo sed -i '/^#\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf
echo "   Synchronizing package databases..."
sudo pacman -Syu --noconfirm
echo


#---------------------------------------------------------------------
# 3. INSTALL ALL PACKAGES FROM pkglist.txt
#---------------------------------------------------------------------
echo "-> [3/6] Installing all packages from pkglist.txt..."
# We use paru to install from both official repos and the AUR.
# --needed prevents re-installing packages that are already present.
if [ -f "pkglist.txt" ]; then
    paru -S --noconfirm --needed - < pkglist.txt
else
    echo "   WARNING: pkglist.txt not found. Skipping package installation."
fi
echo


#---------------------------------------------------------------------
# 4. SYMLINK DOTFILES USING GNU STOW
#---------------------------------------------------------------------
echo "-> [4/6] Symlinking dotfiles using Stow..."
# The -R flag tells stow to "restow", cleaning up old links and relinking.
# Add all your application config folders here.
 
make

echo

#=====================================================================
# 4. INSTALL GTK & ICON THEMES
#=====================================================================
echo "-> [4/8] Installing GTK themes and icons..."
# We clone the repos to the home directory, run the installers, and then clean up.
# The installers need sudo to place files in /usr/share/themes and /usr/share/icons.

# Install Layan GTK Theme
echo "   Installing Layan GTK Theme..."
git clone https://github.com/vinceliuice/Layan-gtk-theme.git ~/Layan-gtk-theme
(cd ~/Layan-gtk-theme && sudo ./install.sh -c dark -l)
rm -rf ~/Layan-gtk-theme

# Install Tela Icon Theme
echo "   Installing Tela Icon Theme..."
git clone https://github.com/vinceliuice/Tela-icon-theme.git ~/Tela-icon-theme
(cd ~/Tela-icon-theme && sudo ./install.sh ubuntu)
rm -rf ~/Tela-icon-theme
echo


#---------------------------------------------------------------------
# 6. ENABLE SYSTEMD SERVICES
#---------------------------------------------------------------------
echo "-> [5/6] Enabling essential systemd services..."
# The services must be installed before you can enable them.

# Networking
sudo systemctl enable NetworkManager.service
systemctl enable --user waybar
sudo systemctl enable sddm

 

echo


#---------------------------------------------------------------------
# 7. FINAL USER & SYSTEM CONFIGURATION
#---------------------------------------------------------------------
echo "-> [6/6] Performing final configurations..."

echo "Installing Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "   Oh My Zsh is already installed. Skipping."
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
echo

# Change user's default shell to Zsh if it's installed
if command -v zsh &> /dev/null; then
    echo "   Changing default shell to Zsh for user $USER."
    sudo chsh -s $(which zsh) $USER
fi

echo


# --- SCRIPT END ---
echo "##################################################"
echo "###          SETUP COMPLETE! REBOOT NOW        ###"
echo "##################################################"
