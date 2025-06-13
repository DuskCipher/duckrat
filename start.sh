
#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_colored() {
    echo -e "${1}${2}${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check internet connectivity
check_internet() {
    print_colored $BLUE "[+] Checking internet connectivity..."
    if ping -c 1 google.com &> /dev/null; then
        print_colored $GREEN "[+] Internet Status : Online"
        return 0
    else
        print_colored $RED "[-] Internet Status : Offline"
        print_colored $YELLOW "[!] Warning: Some features may not work without internet connection"
        return 1
    fi
}

# Function to display banner
display_banner() {
    print_colored $CYAN "
██████╗░██╗░░░██╗░█████╗░██╗░░██╗██╗░░██╗░█████╗░████████╗
██╔══██╗██║░░░██║██╔══██╗██║░██╔╝██║░░██║██╔══██╗╚══██╔══╝
██║░░██║██║░░░██║██║░░╚═╝█████═╝░███████║███████║░░░██║░░░
██║░░██║██║░░░██║██║░░██╗██╔═██╗░██╔══██║██╔══██║░░░██║░░░
██████╔╝╚██████╔╝╚█████╔╝██║░╚██╗██║░░██║██║░░██║░░░██║░░░
╚═════╝░░╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░"
    print_colored $GREEN "           WELCOME TO PANEL DUCKHAT BY DUSKCIPHER  1.0 "
    echo ""
}

# Function to validate and get user input
get_user_input() {
    while true; do
        echo ""
        print_colored $YELLOW "Please enter your Telegram bot configuration:"
        echo ""

        read -p "Enter your bot token: " BOT_TOKEN
        if [[ -z "$BOT_TOKEN" ]]; then
            print_colored $RED "[!] Bot token cannot be empty. Please try again."
            continue
        fi

        read -p "Enter your chat ID: " CHAT_ID
        if [[ -z "$CHAT_ID" ]]; then
            print_colored $RED "[!] Chat ID cannot be empty. Please try again."
            continue
        fi

        # Validate chat ID is numeric
        if ! [[ "$CHAT_ID" =~ ^-?[0-9]+$ ]]; then
            print_colored $RED "[!] Chat ID must be numeric. Please try again."
            continue
        fi

        # Confirm the input
        echo ""
        print_colored $BLUE "Configuration Summary:"
        print_colored $CYAN "Bot Token: ${BOT_TOKEN:0:10}..."
        print_colored $CYAN "Chat ID: $CHAT_ID"
        echo ""

        read -p "Is this configuration correct? (y/n): " CONFIRM
        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            break
        fi
    done
}

# Function to update index.js with user configuration
update_config() {
    print_colored $BLUE "[+] Updating configuration..."

    if [[ ! -f "index.js" ]]; then
        print_colored $RED "[-] Error: index.js not found!"
        exit 1
    fi

    # Create backup
    cp index.js index.js.backup
    print_colored $GREEN "[+] Backup created: index.js.backup"

    # Update the configuration
    sed -i "s/const token = '.*';/const token = '$BOT_TOKEN';/" index.js
    sed -i "s/const id = '.*';/const id = '$CHAT_ID';/" index.js

    if [[ $? -eq 0 ]]; then
        print_colored $GREEN "[+] Configuration updated successfully!"
    else
        print_colored $RED "[-] Error updating configuration!"
        print_colored $YELLOW "[!] Restoring backup..."
        mv index.js.backup index.js
        exit 1
    fi
}

# Function to install dependencies
install_dependencies() {
    print_colored $BLUE "[+] Installing dependencies..."

    if [[ ! -f "package.json" ]]; then
        print_colored $RED "[-] Error: package.json not found!"
        exit 1
    fi

    npm install
    if [[ $? -eq 0 ]]; then
        print_colored $GREEN "[+] Dependencies installed successfully!"
    else
        print_colored $RED "[-] Error installing dependencies!"
        exit 1
    fi
}

# Function to create necessary directories
create_directories() {
    print_colored $BLUE "[+] Creating necessary directories..."

    directories=("uploadedFile" "logs" "temp")
    for dir in "${directories[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            print_colored $GREEN "[+] Created directory: $dir"
        else
            print_colored $YELLOW "[!] Directory already exists: $dir"
        fi
    done
}

# Function to check and create required files
check_files() {
    print_colored $BLUE "[+] Checking required files..."

    required_files=("index.js" "package.json" "web-control.html")
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            print_colored $RED "[-] Error: Required file not found: $file"
            exit 1
        else
            print_colored $GREEN "[+] Found: $file"
        fi
    done
}

# Function to start the server
start_server() {
    print_colored $BLUE "[+] Starting DuckHat server..."
    print_colored $CYAN "[+] Server will be available at: http://localhost:5000"
    print_colored $CYAN "[+] Web control panel: http://localhost:5000/web-control"
    print_colored $CYAN "[+] File manager: http://localhost:5000/uploadedFile"
    echo ""
    print_colored $GREEN "[+] Server is starting... Press Ctrl+C to stop"
    echo ""

    # Start the Node.js server
    node index.js
}

# Function to handle script interruption
cleanup() {
    echo ""
    print_colored $YELLOW "[!] Received interrupt signal. Cleaning up..."
    print_colored $YELLOW "[!] Server stopped."
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Main execution
main() {
    clear
    display_banner

    # Check if Node.js is installed
    if ! command_exists node; then
        print_colored $RED "[-] Error: Node.js is not installed!"
        print_colored $YELLOW "[!] Please install Node.js first."
        exit 1
    fi

    # Check if npm is installed
    if ! command_exists npm; then
        print_colored $RED "[-] Error: npm is not installed!"
        print_colored $YELLOW "[!] Please install npm first."
        exit 1
    fi

    # Check internet connectivity
    check_internet

    # Check required files
    check_files

    # Create necessary directories
    create_directories

    # Get user configuration
    get_user_input

    # Update configuration
    update_config

    # Install dependencies
    install_dependencies

    # Start the server
    start_server
}

# Run main function
main "$@"
