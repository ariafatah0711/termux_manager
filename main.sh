#!/bin/bash
# cd "$(dirname "$0")" || exit 1
cd "$(dirname "$(readlink -f "$0")")" || exit 1
source "utils"

# Function to check and install required packages
check_requirements() {
    echo -e "${BLUE}Checking required packages...${NC}"
    while read -r package; do
        if ! command -v "$package" &> /dev/null; then
            echo -e "${YELLOW}Installing $package...${NC}"
            pkg install -y "$package"
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ $package installed successfully${NC}"
            else
                echo -e "${RED}✗ Failed to install $package${NC}"
                exit 1
            fi
        else
            echo -e "${GREEN}✓ $package is already installed${NC}"
        fi
    done < req
    echo -e "${GREEN}All requirements satisfied!${NC}\n"
}

# Function to check service status
check_service() {
    local service_name=$1
    local process_name=$2
    local menu_width=40
    
    if pgrep -f "$process_name" > /dev/null; then
        echo -e "${BLUE}║${GREEN} ✓ $service_name$(printf ' %.0s' $(seq 1 $(($menu_width-${#service_name}-5))))${BLUE}  ║${NC}"
    elif ps aux | grep -v grep | grep -q "$process_name"; then
        echo -e "${BLUE}║${GREEN} ✓ $service_name$(printf ' %.0s' $(seq 1 $(($menu_width-${#service_name}-5))))${BLUE}  ║${NC}"
    else
        echo -e "${BLUE}║${RED} ✗ $service_name$(printf ' %.0s' $(seq 1 $(($menu_width-${#service_name}-5))))${BLUE}  ║${NC}"
    fi
}

# Function to display menu
show_menu() {
    clear
    # Get menu title from config and add extra space
    local title=" $(jq -r '.menu_title' config.json) "
    local menu_width=40
    local ip=$(get_ip)
    local ip_display="IP: ${ip:-Not Connected}"

    # Info tambahan
    local uptime=$(uptime -p)
    local user=$(whoami)
    local tty=$(tty)
    local ram=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
    local disk=$(df -h $HOME | awk 'NR==2 {print $3 "/" $2}')
    local shell_count=$(ps aux | grep -E 'zsh|bash' | grep -v grep | wc -l)

    echo -e "${BLUE}╔$(printf '═%.0s' $(seq 1 $menu_width))╗${NC}"

    local tpad=$(( (menu_width - ${#title}) / 2 ))
    echo -e "${BLUE}║$(printf ' %.0s' $(seq 1 $tpad))$title$(printf ' %.0s' $(seq 1 $((menu_width - ${#title} - tpad))))║${NC}"
    
    echo -e "${BLUE}╠$(printf '═%.0s' $(seq 1 $menu_width))╣${NC}"

    # IP
    local raw_ip_len=${#ip_display}
    if [ -n "$ip" ]; then echo -e "${BLUE}║ ${GREEN}$ip_display${NC}$(printf ' %.0s' $(seq 1 $((menu_width - raw_ip_len - 1))))${BLUE}║${NC}"
    else echo -e "${BLUE}║ ${RED}$ip_display${NC}$(printf ' %.0s' $(seq 1 $((menu_width - raw_ip_len - 1))))${BLUE}║${NC}"; fi

    # 2 kolom rapi dengan fixed width
    local user_disp="User: $user"
    local tty_disp="TTY: $tty"
    local ram_disp="RAM: $ram"
    local disk_disp="Disk: $disk"
    # Format dengan printf biar rata: kolom 1 = 20 char, kolom 1 = sisa
    line1=$(printf "%-20s %s" "$user_disp" "$tty_disp")
    line2=$(printf "%-20s %s" "$ram_disp" "$disk_disp")
    
    echo -e "${BLUE}║ ${GREEN}$line1${NC}$(printf ' %.0s' $(seq 1 $((menu_width - ${#line1} - 1))))${BLUE}║${NC}"
    echo -e "${BLUE}║ ${YELLOW}$line2${NC}$(printf ' %.0s' $(seq 1 $((menu_width - ${#line2} - 1))))${BLUE}║${NC}"
    # Aktif shell
    # local cdisp="TTY Active: $shell_count"
    # echo -e "${BLUE}║ ${CYAN}$cdisp${NC}$(printf ' %.0s' $(seq 1 $((menu_width - ${#cdisp} - 1))))${BLUE}║${NC}"

    echo -e "${BLUE}╠$(printf '═%.0s' $(seq 1 $menu_width))╣${NC}"

    # Check services from config
    while IFS=$'\t' read -r name process; do
        check_service "$name" "$process"
    done < <(jq -r '.services[] | [.name, .process] | @tsv' config.json)
    
    echo -e "${BLUE}╠$(printf '═%.0s' $(seq 1 $menu_width))╣${NC}"
    
    # Read menu items from config
    local i=1
    while read -r name path; do
        local padding=$((menu_width - ${#name} - 4))
        echo -e "${BLUE}║ $i. $name$(printf ' %.0s' $(seq 1 $padding))║${NC}"
        ((i++))
    done < <(jq -r '.scripts[] | [.name, .path] | @tsv' config.json)
    
    local quit_text="q. quit"
    local quit_padding=$((menu_width - ${#quit_text} - 1))
    
    echo -e "${BLUE}║ $quit_text$(printf ' %.0s' $(seq 1 $quit_padding))║${NC}"
    echo -e "${BLUE}╚$(printf '═%.0s' $(seq 1 $menu_width))╝${NC}"
}

# Function to handle menu selection
handle_menu_choice() {
    local choice=$1
    local total_items=$(($(jq '.scripts | length' config.json)))
    
    # Check for quit command
    if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
        echo -e "${GREEN}Goodbye!${NC}"
        exit 0
    fi
    
    if [[ $choice -ge 1 && $choice -le $total_items ]]; then
        # Get the script path for the selected option
        local script_path=$(jq -r ".scripts[$((choice-1))].path" config.json)
        
        # Jalankan script dalam subshell baru
        (
            # Jalankan script
            bash "$script_path"
        )
        
        # Cek exit code dari subshell
        if [ $? -eq 1 ]; then
            # Jika script dihentikan dengan Ctrl+C, kembali ke menu utama
            return 0
        fi
    else
        echo -e "${RED}Invalid option!${NC}"
        sleep 1
    fi
}

# Check requirements before starting
check_requirements

# Main loop
while true; do
    stty -echo
    show_menu
    sleep 0.05
    # Flush input buffer
    if [ -t 0 ]; then
        while IFS= read -r -t 0.01 -n 10000; do : ; done
    fi
    stty echo
    read -e -p "Select an option: " choice
    handle_menu_choice "$choice"
done 