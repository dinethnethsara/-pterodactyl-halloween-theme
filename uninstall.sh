#!/bin/bash

#####################################################################
# Pterodactyl Halloween Theme Uninstaller
# BERMUDA Pterodactyl Panel
# Version: 1.0.0
#####################################################################

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${PURPLE}"
cat << "EOF"
╔═══════════════════════════════════════════════════╗
║                                                   ║
║   🎃 PTERODACTYL HALLOWEEN THEME UNINSTALLER 🎃  ║
║                                                   ║
║         BERMUDA Pterodactyl Panel                 ║
║                                                   ║
╚═══════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

log_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root or with sudo"
    exit 1
fi

log_info "Searching for Pterodactyl installation..."

PANEL_DIR=""
POSSIBLE_PATHS=(
    "/var/www/pterodactyl"
    "/var/www/html/pterodactyl"
    "/var/www/panel"
)

for path in "${POSSIBLE_PATHS[@]}"; do
    if [[ -f "$path/artisan" ]]; then
        PANEL_DIR="$path"
        log_success "Found at: $PANEL_DIR"
        break
    fi
done

if [[ -z "$PANEL_DIR" ]]; then
    log_error "Pterodactyl Panel not found"
    exit 1
fi

log_info "Looking for backups..."
BACKUP_DIR=$(find /var/backups -maxdepth 1 -type d -name "pterodactyl-halloween-*" 2>/dev/null | sort -r | head -n 1)

if [[ -n "$BACKUP_DIR" ]]; then
    log_success "Found backup: $BACKUP_DIR"
    
    if [[ -f "$BACKUP_DIR/wrapper.blade.php.backup" ]]; then
        cp "$BACKUP_DIR/wrapper.blade.php.backup" "$PANEL_DIR/resources/views/templates/wrapper.blade.php"
        log_success "Restored original wrapper.blade.php"
    fi
else
    log_warning "No backup found, removing theme manually"
    
    WRAPPER_FILE="$PANEL_DIR/resources/views/templates/wrapper.blade.php"
    if [[ -f "$WRAPPER_FILE" ]]; then
        sed -i '/halloween\.css/d' "$WRAPPER_FILE"
        sed -i '/bermuda-watermark/d' "$WRAPPER_FILE"
        sed -i '/bermuda-footer/d' "$WRAPPER_FILE"
        sed -i '/halloween-particles/d' "$WRAPPER_FILE"
        sed -i '/fog-layer/d' "$WRAPPER_FILE"
        log_success "Removed theme references"
    fi
fi

log_info "Removing theme files..."
rm -rf "$PANEL_DIR/public/themes/halloween"
log_success "Theme files removed"

log_info "Clearing cache..."
cd "$PANEL_DIR"
php artisan view:clear 2>/dev/null
php artisan config:clear 2>/dev/null
php artisan cache:clear 2>/dev/null
log_success "Cache cleared"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}║  🎃 UNINSTALLATION COMPLETE! 🎃                  ║${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
log_success "Theme removed successfully!"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo -e "  1. Clear your browser cache"
echo -e "  2. Refresh your Pterodactyl Panel"
echo -e "  3. Panel should be back to default theme"
echo ""
