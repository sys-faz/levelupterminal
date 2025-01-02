#!/bin/bash
version=1.0
# COLORS

# Normal text colors
R='\e[0;31m'
G='\e[0;32m'
Y='\e[0;33m'
B='\e[0;34m'

# Bold text colors
BR='\e[1;31m'
BG='\e[1;32m'
BY='\e[1;33m'
BB='\e[1;34m'

# Reset text colors
NC='\e[0m'

# Check for root permission
if [[ $EUID != 0  ]]; then
    echo
    echo -e "${BR}ERROR:${NC} Please run this script as ${Y}root${NC} (${Y}sudo${NC})"
    echo
    exit 1
fi

# Introduction and aggrement
aggrement="

${BG}Welcome to Level Up Terminal v$version${NC}

This script is intended for post-installation customization of your Kali Linux VM. 
As the author, I (${BY}Sysfaz${NC}), recommend first running the ${Y}pimpmykali${NC} script to set up a new VM. 
Afterward, this script will tweak your terminal interface and more by performing the following actions:

- Change the shell to ${Y}zsh${NC}.
- Install ${Y}Oh My Zsh${NC} and plugins: ${G}git, tmux, zsh-autosuggestions, zsh-syntax-highlighting, sudo, eza, grc,${NC} and ${G}colorize${NC}.
- Configure ${Y}tmux${NC} with my customized and well documented ${Y}.tmux.conf${NC} file. 
- Configure ${Y}.vimrc${NC} file with my customized and well documented settings.

Backups of your existing configuration files will be stored in ${Y}./bac${NC}, 

${BR}Important:${NC} Do not interrupt the script, as this may create issues. 
Refer to the documentation on ${Y}GitHub${NC} for detailed usage and precautions.

"

echo -e "$aggrement"

read -p "Are you sure you wish to continue? [Y/n] " choice
echo

script_path=$(dirname "$(realpath "$0")")
config_dir="$script_path/config"
backup_dir="$script_path/bac"
font_dir="$script_path/font"

if [[ "$choice" == "Y" || "$choice" == "y" ]]; then

    # Backing up files at ./bac
    echo -e "${BB}Creating backup directory at${NC} ${Y}$script_path/bac${NC}"
    sleep 1.5
    mkdir -p "$script_path/bac"
    echo -e "${BG}Success.${NC}"
    echo

    backupfiles=(
        "$HOME/.bashrc"
        "$HOME/.zshrc"
        "$HOME/.vimrc"
        "$HOME/.tmux.conf"
    )

    echo -e "${BB}Backing up files: ${Y}.bashrc, .zshrc, .vimrc, .tmux.conf${NC}"
    sleep 1.5
    for file in "${backupfiles[@]}"; do
        if [[ -f "$file" ]]; then
            cp "$file" "$backup_dir"/$(basename "$file")
        fi
    done
    echo -e "${BG}Success.${NC}"
    echo

    # Installing ohmyzsh
    if ! command -v zsh >/dev/null 2>&1; then
        echo -e "${BB}zsh${NC} ${Y}not detected.${NC} ${BB}Installing zsh${NC}"
        sleep 1.5
        apt update -y >/dev/null 2>&1 && apt install -y zsh >/dev/null 2>&1
        if command -v zsh >/dev/null 2>&1; then
            echo -e "${BG}Success.${NC}"
            echo
        else
            echo -e "${BR}ERROR:${NC} zsh is ${Y}not installed.${NC} Manually install zsh and re-run the script."
            exit 1
        fi
    fi

    if ! [[ -d "$HOME/.oh-my-zsh" ]]; then
        echo -e "${BB}Installing ohmyzsh${NC}"
        sleep 1.5
        sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null 2>&1
        if [[ -d "$HOME/.oh-my-zsh" ]]; then
            echo -e "${BG}Success.${NC}"
            echo
        else
            echo -e "${BR}ERROR:${NC} ohmyzsh is ${Y}not installed.${NC} Manually install ohmyzsh and re-run the script."
            exit 1
        fi
    fi

    # Replacing .zshrc
    echo -e "${BB}Replacing .zshrc${NC}"
    sleep 1.5
    cp "$config_dir/.zshrc" "$HOME/.zshrc"
    echo -e "${BG}Success.${NC}"
    echo

    # Installing ohmyzsh plugins
    echo -e "${BB}Installing:${NC} ${Y}zsh-autosuggestions${NC}"
    sleep 1.5
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions >/dev/null 2>&1
    echo -e "${BG}Success.${NC}"
    echo
    
    echo -e "${BB}Installing:${NC} ${Y}zsh-syntax-highlighting${NC}"
    sleep 1.5
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting >/dev/null 2>&1
    echo -e "${BG}Success.${NC}"
    echo

    echo -e "${BB}Installing:${NC} ${Y}eza${NC}"
    sleep 1.5
    mkdir -p /etc/apt/keyrings >/dev/null 2>&1
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg >/dev/null 2>&1
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list >/dev/null 2>&1
    chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list >/dev/null 2>&1
    apt update -y >/dev/null 2>&1
    apt install -y eza >/dev/null 2>&1
    echo -e "${BG}Success.${NC}"
    echo

    echo -e "${BB}Installing:${NC} ${Y}grc${NC}"
    sleep 1.5
    apt install -y grc >/dev/null 2>&1
    echo -e "${BG}Success.${NC}"
    echo

    echo -e "${BB}Installing:${NC} ${Y}colorize${NC}"
    sleep 1.5
    apt install -y colorize >/dev/null 2>&1
    echo -e "${BG}Success.${NC}"
    echo

    # Replacing .tmux.conf
    echo -e "${BB}Replacing .tmux.conf${NC}"
    sleep 1.5
    cp "$config_dir/.tmux.conf" "$HOME/.tmux.conf"
    echo -e "${BG}Success.${NC}"
    echo

    # Replacing .vimrc
    if ! command -v vim >/dev/null 2>&1; then
        echo -e "${BB}vim${NC} ${Y}not detected.${NC} ${BB}Installing vim${NC}"
        sleep 1.5
        apt update -y >/dev/null 2>&1 && apt install -y vim >/dev/null 2>&1
        if command -v vim >/dev/null 2>&1; then
            echo -e "${BG}Success.${NC}"
            echo
        else
            echo -e "${BR}ERROR:${NC} vim is ${Y}not installed.${NC} Manually install vim and re-run the script."
            exit 1
        fi
    fi

    echo -e "${BB}Replacing .vimrc${NC}"
    sleep 1.5
    cp "$config_dir/.vimrc" "$HOME/.vimrc"
    echo -e "${BG}Success.${NC}"
    echo
    
    # Installing nerd font
    echo -e "${BB}Installing hack nerd font."
    sleep 1.5
    cp "$font_dir"/* "/usr/share/fonts/"
    echo -e "${BG}Success.${NC}"
    echo

    # Finalising
    bye_msg="
${BG}Installation Complete!${NC}
Please perform these final steps:
1. Change your terminal font to ${Y}Nerd Font Mono${NC}
2. Close and restart your terminal

${BB}Enjoy your customized Kali Linux!${NC}
"

    echo -e "$bye_msg"


elif [[ "$choice" == "N" || "$choice" == "n" ]]; then
    echo
    echo -e "${BR}ABORTED:${NC} Due to wishing not to continue."
    echo
    exit 1
else
    echo
    echo -e "${BR}ABORTED:${NC} Incorrect input provided."
    echo
    exit 1
fi
