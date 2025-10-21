# Installation Guide

## Prerequisites

Before installing, make sure you have:

1. ✅ Pterodactyl Panel 1.11.x installed and working
2. ✅ Root or sudo access to the server
3. ✅ SSH access to the server
4. ✅ Basic command line knowledge

## Installation Steps

### 1. Download the Theme

```bash
# SSH into your server
ssh user@your-server.com

# Navigate to a temporary directory
cd /tmp

# Clone the repository
git clone https://github.com/dinethnethhsara/pterodactyl-halloween-theme.git

# Enter the directory
cd pterodactyl-halloween-theme
```

### 2. Run the Installer

```bash
sudo bash install.sh
```

### 3. What Happens During Installation

The installer will:

1. **Detect Pterodactyl** - Automatically finds your Pterodactyl installation
   - Checks `/var/www/pterodactyl`
   - Checks `/var/www/html/pterodactyl`
   - Checks `/var/www/panel`
   - If not found, you'll be asked to provide the path

2. **Create Backup** - Saves original files to `/var/backups/pterodactyl-halloween-[timestamp]/`
   - Backs up `wrapper.blade.php`
   - Saves panel directory path

3. **Install Theme** - Copies CSS and modifies templates
   - Copies `halloween.css` to `public/themes/halloween/`
   - Adds CSS link to `wrapper.blade.php`
   - Adds watermark and particles
   - Adds footer branding

4. **Set Permissions** - Makes sure files have correct ownership

5. **Clear Cache** - Clears Laravel view, config, and application cache

### 4. Verify Installation

After installation completes:

1. **Check the files:**
```bash
ls -la /var/www/pterodactyl/public/themes/halloween/
# You should see halloween.css
```

2. **Check the backup:**
```bash
ls -la /var/backups/ | grep pterodactyl-halloween
# You should see a backup directory with timestamp
```

### 5. View the Theme

1. **Open your Pterodactyl Panel** in a web browser
2. **Clear browser cache** (CTRL+SHIFT+DELETE) - THIS IS IMPORTANT
3. **Refresh the page** (F5 or CTRL+R)
4. You should see:
   - Purple backgrounds
   - Green buttons
   - Floating Halloween particles
   - "BERMUDA Pterodactyl Panel" watermark in top-right corner

## Troubleshooting Installation

### Problem: "Pterodactyl Panel not found"

**Solution:** Provide the correct path when prompted, for example:
- `/var/www/pterodactyl`
- `/var/www/html/panel`
- `/opt/pterodactyl`

### Problem: "Permission denied"

**Solution:** Run with sudo:
```bash
sudo bash install.sh
```

### Problem: Installation completes but theme doesn't show

**Solutions:**
1. Clear browser cache (CTRL+SHIFT+DELETE)
2. Try hard refresh (CTRL+F5)
3. Clear Laravel cache:
```bash
cd /var/www/pterodactyl
sudo php artisan view:clear
sudo php artisan config:clear
sudo php artisan cache:clear
```

### Problem: CSS file exists but theme doesn't apply

**Check if CSS link was added:**
```bash
grep "halloween.css" /var/www/pterodactyl/resources/views/templates/wrapper.blade.php
```

If no output, the CSS wasn't injected. Try running installer again.

## Manual Installation

If automatic installation fails, you can install manually:

### Step 1: Copy CSS

```bash
sudo mkdir -p /var/www/pterodactyl/public/themes/halloween
sudo cp theme/halloween.css /var/www/pterodactyl/public/themes/halloween/
```

### Step 2: Edit wrapper.blade.php

```bash
sudo nano /var/www/pterodactyl/resources/views/templates/wrapper.blade.php
```

Add before `</head>`:
```html
    <link rel="stylesheet" href="{{ asset('themes/halloween/halloween.css') }}">
</head>
```

Add after `<body>`:
```html
<body>
    <div class="bermuda-watermark">BERMUDA Pterodactyl Panel</div>
    <div class="halloween-particles">
        <div class="halloween-particle">👻</div>
        <div class="halloween-particle">🦇</div>
        <div class="halloween-particle">🎃</div>
        <div class="halloween-particle">👻</div>
        <div class="halloween-particle">🦇</div>
        <div class="halloween-particle">🕷️</div>
    </div>
    <div class="fog-layer"></div>
```

Add before `</body>`:
```html
    <div class="bermuda-footer">Themed by BERMUDA Pterodactyl Panel</div>
</body>
```

Save and exit (CTRL+X, then Y, then Enter)

### Step 3: Set Permissions

```bash
sudo chown -R www-data:www-data /var/www/pterodactyl/public/themes/halloween
sudo chmod -R 755 /var/www/pterodactyl/public/themes/halloween
```

Note: Replace `www-data` with `nginx` if you use Nginx, or `apache` if you use Apache.

### Step 4: Clear Cache

```bash
cd /var/www/pterodactyl
sudo php artisan view:clear
sudo php artisan config:clear
sudo php artisan cache:clear
```

### Step 5: View Theme

Clear browser cache and refresh!

## Uninstallation

To remove the theme:

```bash
cd /tmp/pterodactyl-halloween-theme
sudo bash uninstall.sh
```

This will:
- Restore original `wrapper.blade.php` from backup
- Delete `public/themes/halloween/` directory
- Clear Laravel cache

## Need Help?

If you're stuck:

1. Check the troubleshooting section above
2. Make sure you're running Pterodactyl 1.11.x
3. Make sure you have root/sudo access
4. Check that your Pterodactyl installation is working before installing the theme
5. Open an issue on GitHub with details of the problem

## Important Notes

- ⚠️ The installer modifies `wrapper.blade.php` - a backup is created automatically
- ⚠️ Always test on a staging environment first if possible
- ⚠️ Clear browser cache after installation
- ✅ Installation is reversible using the uninstaller
- ✅ Original files are backed up before any changes

---

**BERMUDA Pterodactyl Panel**
