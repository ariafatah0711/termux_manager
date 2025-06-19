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
    
    echo -e "${BLUE}╔$(printf '═%.0s' $(seq 1 $menu_width))╗${NC}"
    echo -e "${BLUE}║$(printf ' %.0s' $(seq 1 $((($menu_width-${#title})/2))))$title$(printf ' %.0s' $(seq 1 $((($menu_width-${#title})/2))))║${NC}"
    echo -e "${BLUE}╠$(printf '═%.0s' $(seq 1 $menu_width))╣${NC}"
    
    # Display IP address
    if [ -n "$ip" ]; then
        echo -e "${BLUE}║ ${GREEN}$ip_display$(printf ' %.0s' $(seq 1 $(($menu_width-${#ip_display}-1))))${BLUE}║${NC}"
    else
        echo -e "${BLUE}║ ${RED}$ip_display$(printf ' %.0s' $(seq 1 $(($menu_width-${#ip_display}-1))))${BLUE}║${NC}"
    fi
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
    echo -n "Select an option: "
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
    show_menu
    read -e choice
    handle_menu_choice "$choice"
done 