#!/bin/bash

# System-wide installation script for Omazed (mirrors AUR PKGBUILD layout)
# Installs to /usr/bin/ and /usr/share/doc/omazed/
# Run with: sudo bash install-system.sh

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="omazed"
GENERATOR_SCRIPT="omazed-generator.sh"
TEMPLATE_FILE="omazed-theme.tpl"

log() { echo -e "${GREEN}[INFO]${NC} $* "; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }
info() { echo -e "${BLUE}[INFO]${NC} $*"; }

print_banner() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║                  Omazed System Install                    ║
║           Live theme switching for zed in omarchy         ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root (use sudo)"
        exit 1
    fi
}

check_files() {
    local missing=0
    for f in "$SCRIPT_DIR/$MAIN_SCRIPT" "$SCRIPT_DIR/$GENERATOR_SCRIPT" "$SCRIPT_DIR/$TEMPLATE_FILE"; do
        if [[ ! -f "$f" ]]; then
            error "Required file not found: $f"
            missing=1
        fi
    done
    if [[ $missing -eq 1 ]]; then
        exit 1
    fi
}

install_files() {
    log "Installing to /usr/bin/..."

    install -Dm755 "$SCRIPT_DIR/$MAIN_SCRIPT" /usr/bin/omazed
    install -Dm755 "$SCRIPT_DIR/$GENERATOR_SCRIPT" /usr/bin/omazed-generator.sh
    install -Dm644 "$SCRIPT_DIR/$TEMPLATE_FILE" /usr/bin/omazed-theme.tpl

    log "Installing documentation..."
    install -Dm644 "$SCRIPT_DIR/README.md" /usr/share/doc/omazed/README.md

    log "Main script installed: /usr/bin/omazed ✓"
    log "Generator script installed: /usr/bin/omazed-generator.sh ✓"
    log "Template file installed: /usr/bin/omazed-theme.tpl ✓"
    log "Documentation installed: /usr/share/doc/omazed/README.md ✓"
}

run_user_setup() {
    local user="${SUDO_USER:-$USER}"

    if [[ "$user" == "root" ]]; then
        warn "Running as root directly — skipping user-level setup"
        warn "The installing user should run: omazed setup"
        return
    fi

    log "Running setup for user: $user"
    echo ""

    if command -v omazed >/dev/null 2>&1; then
        if sudo -u "$user" omazed setup 2>&1; then
            log "User setup completed ✓"
        else
            warn "User setup had issues — run manually: omazed setup"
        fi
    else
        warn "omazed not in PATH for root — skipping user setup"
        warn "Run as the target user: omazed setup"
    fi
}

print_completion() {
    cat << EOF

╔═══════════════════════════════════════════════════════════╗
║              SYSTEM INSTALLATION COMPLETE!                ║
╚═══════════════════════════════════════════════════════════╝

🎉 Omazed installed system-wide!

📋 WHAT WAS INSTALLED:
   • /usr/bin/omazed
   • /usr/bin/omazed-generator.sh
   • /usr/bin/omazed-theme.tpl
   • /usr/share/doc/omazed/README.md

🔧 NEXT STEPS:
   Run as your normal user to complete setup:
     omazed setup

EOF
}

main() {
    print_banner
    log "Starting system-wide installation..."

    check_root
    check_files
    install_files
    run_user_setup
    print_completion
}

main "$@"
