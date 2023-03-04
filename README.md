# wsl-install-no-store
PowerShell Scripts to install and setup WSL without the Windows Store

# Prerequisites
Enable PowerShell scripts with 'Set-ExecutionPolicy -ExecutionPolicy Unrestricted'

# As an admin user
Run 1_wsl_install_admin.ps1

This script enables WSL and Virtual Machine Platform and then restarts your computer to allow the setup to complete.

# As your user
Run 2_wsl_install_user.ps1

This script:
1. Prompts for your username and password (This is kept in memory and secure, and cleaned up after!)
2. Updates the WSL kernel
3. Sets the default version to WSLv2
4. Installs the latest LTS Ubuntu Jammy
5. Sets up the User and sudo rights
6. Enables Systemd
7. Installs Docker
