#!/bin/bash

#####################################################################
# Pterodactyl Halloween Theme Installer
# BERMUDA Pterodactyl Panel
# Version: 1.0.3
#####################################################################

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

BACKUP_DIR="/var/backups/pterodactyl-halloween-$(date +%Y%m%d_%H%M%S)"
PANEL_DIR=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${PURPLE}"
cat << "EOF"
╔═══════════════════════════════════════════════════╗
║                                                   ║
║    🎃 PTERODACTYL HALLOWEEN THEME INSTALLER 🎃   ║
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

log_info "Detecting Pterodactyl Panel installation..."

POSSIBLE_PATHS=(
    "/var/www/pterodactyl"
    "/var/www/html/pterodactyl"
    "/var/www/panel"
)

for path in "${POSSIBLE_PATHS[@]}"; do
    if [[ -f "$path/artisan" ]] && [[ -d "$path/app" ]]; then
        PANEL_DIR="$path"
        log_success "Found Pterodactyl Panel at: $PANEL_DIR"
        break
    fi
done

if [[ -z "$PANEL_DIR" ]]; then
    log_error "Pterodactyl Panel not found in common locations"
    read -p "Enter Pterodactyl Panel path (or CTRL+C to exit): " PANEL_DIR
    if [[ ! -f "$PANEL_DIR/artisan" ]]; then
        log_error "Invalid path! artisan file not found"
        exit 1
    fi
fi

detect_and_remove_old_themes() {
    log_info "Checking for previously installed themes..."
    
    local found_themes=false
    local theme_dirs=()
    local theme_css=()
    
    if [[ -d "$PANEL_DIR/public/themes" ]]; then
        while IFS= read -r theme_dir; do
            local theme_name=$(basename "$theme_dir")
            if [[ "$theme_name" != "halloween" ]] && [[ -d "$theme_dir" ]]; then
                theme_dirs+=("$theme_dir")
                found_themes=true
            fi
        done < <(find "$PANEL_DIR/public/themes" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
    fi
    
    WRAPPER_FILE="$PANEL_DIR/resources/views/templates/wrapper.blade.php"
    if [[ -f "$WRAPPER_FILE" ]]; then
        while IFS= read -r line; do
            if [[ "$line" != *"halloween.css"* ]]; then
                theme_css+=("$line")
                found_themes=true
            fi
        done < <(grep -E "themes/.*\.css|<link.*theme" "$WRAPPER_FILE" 2>/dev/null || true)
    fi
    
    if [[ "$found_themes" == true ]]; then
        echo ""
        log_warning "Found previously installed themes:"
        echo ""
        
        if [[ ${#theme_dirs[@]} -gt 0 ]]; then
            echo -e "${YELLOW}Theme directories:${NC}"
            for dir in "${theme_dirs[@]}"; do
                echo "  - $(basename "$dir") ($(du -sh "$dir" 2>/dev/null | cut -f1))"
            done
            echo ""
        fi
        
        if [[ ${#theme_css[@]} -gt 0 ]]; then
            echo -e "${YELLOW}Theme CSS references in wrapper.blade.php:${NC}"
            for css in "${theme_css[@]}"; do
                echo "  - ${css}"
            done
            echo ""
        fi
        
        echo -e "${YELLOW}┌────────────────────────────────────────────────────┐${NC}"
        echo -e "${YELLOW}│ Previous themes can cause conflicts!              │${NC}"
        echo -e "${YELLOW}│ It's recommended to remove them first.            │${NC}"
        echo -e "${YELLOW}└────────────────────────────────────────────────────┘${NC}"
        echo ""
        
        read -p "Do you want to remove previous themes? (y/n): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Removing previous themes..."
            
            for dir in "${theme_dirs[@]}"; do
                local theme_name=$(basename "$dir")
                log_info "Removing theme directory: $theme_name"
                rm -rf "$dir"
                log_success "Removed: $theme_name"
            done
            
            if [[ ${#theme_css[@]} -gt 0 ]] && [[ -f "$WRAPPER_FILE" ]]; then
                log_info "Cleaning theme references from wrapper.blade.php..."
                cp "$WRAPPER_FILE" "$WRAPPER_FILE.pre-cleanup.backup"
                sed -i '/themes\/.*\.css/d' "$WRAPPER_FILE"
                sed -i '/<link.*theme/d' "$WRAPPER_FILE"
                log_success "Removed theme CSS references"
            fi
            
            log_success "Previous themes removed successfully!"
            echo ""
        else
            log_warning "Keeping previous themes. This may cause conflicts!"
            echo ""
            read -p "Continue anyway? (y/n): " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "Installation cancelled"
                exit 0
            fi
        fi
    else
        log_success "No previous themes found"
    fi
}

detect_and_remove_old_themes

log_info "Creating backup directory..."
mkdir -p "$BACKUP_DIR"
echo "$PANEL_DIR" > "$BACKUP_DIR/panel_path.txt"
log_success "Backup directory: $BACKUP_DIR"

log_info "Installing theme files..."
mkdir -p "$PANEL_DIR/public/themes/halloween"
cp "$SCRIPT_DIR/theme/halloween.css" "$PANEL_DIR/public/themes/halloween/"

if [[ -d "$SCRIPT_DIR/theme/images" ]]; then
    cp -r "$SCRIPT_DIR/theme/images" "$PANEL_DIR/public/themes/halloween/"
    log_success "Theme CSS and images installed"
else
    log_success "Theme CSS installed"
    log_warning "Images folder not found (optional)"
fi

log_info "Injecting CSS into Pterodactyl..."

WRAPPER_FILE="$PANEL_DIR/resources/views/templates/wrapper.blade.php"

if [[ -f "$WRAPPER_FILE" ]]; then
    cp "$WRAPPER_FILE" "$BACKUP_DIR/wrapper.blade.php.backup"
    
    if ! grep -q "halloween.css" "$WRAPPER_FILE"; then
        sed -i 's|</head>|    <link rel="stylesheet" href="{{ asset('"'"'themes/halloween/halloween.css'"'"') }}">\n</head>|' "$WRAPPER_FILE"
        log_success "CSS injected into wrapper.blade.php"
    else
        log_warning "Theme already installed in wrapper.blade.php"
    fi
    
    if ! grep -q "bermuda-watermark" "$WRAPPER_FILE"; then
        sed -i 's|<body[^>]*>|&\n    <div class="bermuda-watermark">BERMUDA Pterodactyl Panel</div>\n    <div class="halloween-particles">\n        <div class="halloween-particle">👻</div>\n        <div class="halloween-particle">🦇</div>\n        <div class="halloween-particle">🎃</div>\n        <div class="halloween-particle">👻</div>\n        <div class="halloween-particle">🦇</div>\n        <div class="halloween-particle">🕷️</div>\n    </div>\n    <div class="fog-layer"></div>|' "$WRAPPER_FILE"
        log_success "Watermark and effects added"
    fi
    
    if ! grep -q "bermuda-footer" "$WRAPPER_FILE"; then
        sed -i 's|</body>|    <div class="bermuda-footer">Themed by BERMUDA Pterodactyl Panel</div>\n</body>|' "$WRAPPER_FILE"
    fi
else
    log_warning "wrapper.blade.php not found at $WRAPPER_FILE"
fi

log_info "Setting permissions..."
chown -R www-data:www-data "$PANEL_DIR/public/themes/halloween" 2>/dev/null || \
chown -R nginx:nginx "$PANEL_DIR/public/themes/halloween" 2>/dev/null || \
chown -R apache:apache "$PANEL_DIR/public/themes/halloween" 2>/dev/null || \
log_warning "Could not set ownership"

chmod -R 755 "$PANEL_DIR/public/themes/halloween"
log_success "Permissions set"

log_info "Clearing cache..."
cd "$PANEL_DIR"
php artisan view:clear 2>/dev/null || log_warning "Could not clear view cache"
php artisan config:clear 2>/dev/null || log_warning "Could not clear config cache"
php artisan cache:clear 2>/dev/null || log_warning "Could not clear cache"
log_success "Cache cleared"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}║  🎃 INSTALLATION COMPLETE! 🎃                    ║${NC}"
echo -e "${GREEN}║                                                   ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
log_success "Theme installed successfully!"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo -e "  1. Clear your browser cache (CTRL+SHIFT+DELETE)"
echo -e "  2. Refresh your Pterodactyl Panel"
echo -e "  3. You should see the Halloween theme with purple/green colors"
echo ""
echo -e "${CYAN}Backup location:${NC} $BACKUP_DIR"
echo -e "${CYAN}To uninstall:${NC} Run ./uninstall.sh"
echo ""
echo -e "${PURPLE}BERMUDA Pterodactyl Panel${NC}"
echo ""
