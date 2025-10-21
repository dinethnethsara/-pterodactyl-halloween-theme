# 🎃 Pterodactyl Halloween Theme

**BERMUDA Pterodactyl Panel**

A Halloween-themed CSS modification for Pterodactyl Panel 1.11.x featuring purple and green colors, floating Halloween particles, and custom branding.

---

## ⚠️ Important Notes

- This is a **CSS overlay theme** that modifies the appearance of Pterodactyl Panel
- It does NOT modify core Pterodactyl files
- It adds a CSS file and modifies the blade template to include it
- **Backup is created before installation**
- Tested on Pterodactyl Panel 1.11.x

---

## 🎨 Features

### 🎯 Complete Admin Panel Styling (NEW in v1.0.3!)
- **Beautiful Admin Navigation**: Gradient purple background with green border
- **Styled Admin Sidebar**: Hover effects, active states, smooth transitions
- **Admin Dashboard Cards**: Glowing statistics cards with large numbers
- **Admin Tables**: Alternating rows, hover effects, rounded corners
- **Admin Forms**: Rounded inputs, labeled fields, beautiful layouts
- **Admin Tabs**: Active state highlighting with green accent
- **Admin Search**: Pill-shaped search bar with glow on focus
- **Admin Badges & Labels**: Rounded, colored, professional
- **Admin Pagination**: Rounded page buttons with active states
- **Admin Modals**: Consistent with main theme styling
- **Admin Toggle Switches**: Smooth animated switches
- **Admin Empty States**: Friendly messages with pumpkin emoji
- **Admin Watermark**: "BERMUDA Pterodactyl Panel - Admin Panel" at bottom

### 🖼️ Beautiful Images (v1.0.2)
- **Professional BERMUDA Logo**: Glowing pterodactyl logo with Halloween elements
- **Stunning Login Background**: Full-screen haunted castle with purple moon
- **Navigation Logo**: Sleek pterodactyl with green glow
- **5 High-Quality Images**: Total 13 MB of beautiful Halloween artwork

### 💎 Beautiful Login Page (v1.0.2)
- **Full-Screen Background**: Atmospheric Halloween scene
- **Rounded Login Card**: 25px border-radius with gradient background
- **Super Rounded Buttons**: 50px border-radius with glowing green gradient
- **Button Animation**: Pumpkin emoji (🎃) appears on login button
- **Professional Design**: Blur overlay, smooth animations, perfect spacing
- **Glow Effects**: Inputs glow green on focus with smooth transitions

### Visual Changes
- **Purple/Green Color Scheme**: Deep purple backgrounds with toxic green accents
- **Rounded Buttons Everywhere**: All buttons have beautiful 50px rounded corners
- **Custom Scrollbars**: Purple and green styled scrollbars
- **Themed Inputs**: Rounded inputs (15px) with purple borders and green glow on focus
- **Professional Gradients**: Smooth color transitions throughout

### Effects
- **Floating Particles**: 6 Halloween emoji particles (ghosts, bats, pumpkins, spiders) floating on screen
- **Purple Fog**: Animated fog effect at the bottom of pages
- **Smooth Animations**: Hover effects and transitions
- **Watermark**: "BERMUDA Pterodactyl Panel" watermark in top-right corner
- **Footer Branding**: "Themed by BERMUDA Pterodactyl Panel" in footer

### Smart Installation
- **Automatically detects previous themes** and offers to remove them
- Shows what themes are currently installed
- Prevents conflicts with other theme modifications
- Creates backups before any changes

### Responsive
- Works on desktop and mobile devices
- Particles are disabled on mobile for better performance
- Supports reduced motion preferences

---

## 📋 Requirements

- **Pterodactyl Panel**: Version 1.11.x
- **Server Access**: Root or sudo privileges
- **Web Server**: Apache or Nginx
- **PHP**: 7.4+ (whatever your Pterodactyl installation requires)

---

## 🚀 Installation

### Automatic Installation (Recommended)

1. **Clone or download this repository:**
```bash
git clone https://github.com/dinethnethhsara/pterodactyl-halloween-theme.git
cd pterodactyl-halloween-theme
```

2. **Run the installer:**
```bash
sudo bash install.sh
```

3. **Clear your browser cache** (CTRL+SHIFT+DELETE)

4. **Refresh your Pterodactyl Panel**

### What the Installer Does

1. Detects your Pterodactyl Panel installation directory
2. **Scans for previously installed themes** and offers to remove them to prevent conflicts
3. Creates a backup of modified files in `/var/backups/pterodactyl-halloween-[timestamp]/`
4. Copies `halloween.css` to `public/themes/halloween/`
5. Modifies `resources/views/templates/wrapper.blade.php` to:
   - Include the Halloween CSS file
   - Add the BERMUDA watermark
   - Add Halloween particle effects
   - Add footer branding
6. Sets proper file permissions
7. Clears Laravel cache

---

## 🗑️ Uninstallation

### Automatic Uninstallation

```bash
cd pterodactyl-halloween-theme
sudo bash uninstall.sh
```

### What the Uninstaller Does

1. Finds your Pterodactyl installation
2. Looks for backup files
3. Restores original `wrapper.blade.php` if backup exists
4. OR removes theme-related lines if no backup found
5. Deletes `/public/themes/halloween/` directory
6. Clears Laravel cache

---

## 🎨 Color Palette

The theme uses these colors:

```css
Deep Purple Dark:  #1A0B2E
Purple Mid:        #2D1B4E
Purple Accent:     #6B2C91
Purple Bright:     #8B3AB8
Toxic Green:       #39FF14
Neon Green:        #00FF41
Ghost White:       #E8E8E8
Halloween Orange:  #FF6B35
Blood Red:         #8B0000
```

---

## 🔧 Manual Installation

If you prefer to install manually:

1. **Copy CSS file:**
```bash
mkdir -p /var/www/pterodactyl/public/themes/halloween
cp theme/halloween.css /var/www/pterodactyl/public/themes/halloween/
```

2. **Edit wrapper.blade.php:**

Add before `</head>`:
```html
<link rel="stylesheet" href="{{ asset('themes/halloween/halloween.css') }}">
```

Add after `<body>` tag:
```html
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
```

3. **Clear cache:**
```bash
cd /var/www/pterodactyl
php artisan view:clear
php artisan config:clear
php artisan cache:clear
```

4. **Clear browser cache and refresh**

---

## 🐛 Troubleshooting

### Theme Not Showing?

1. **Clear browser cache** - This is the most common issue
   - Chrome/Firefox/Edge: Press `CTRL+SHIFT+DELETE`
   - Select "Cached images and files"
   - Clear and refresh

2. **Clear Laravel cache:**
```bash
cd /var/www/pterodactyl  # or your panel directory
php artisan view:clear
php artisan config:clear
php artisan cache:clear
```

3. **Check file exists:**
```bash
ls -la /var/www/pterodactyl/public/themes/halloween/halloween.css
```

4. **Check wrapper.blade.php was modified:**
```bash
grep "halloween.css" /var/www/pterodactyl/resources/views/templates/wrapper.blade.php
```

5. **Check browser console** (F12) for any 404 errors

### Particles Not Showing?

- Particles are disabled on mobile devices for performance
- Check if you have "Reduce Motion" enabled in your OS settings
- They may be hidden behind content - they have a low z-index

### Colors Look Wrong?

- Make sure browser cache is cleared
- Try hard refresh: `CTRL+F5`
- Check if another theme or custom CSS is conflicting

---

## ⚙️ Customization

You can customize colors by editing `theme/halloween.css`:

```css
:root {
    --halloween-purple-dark: #1A0B2E;    /* Change this */
    --halloween-green-toxic: #39FF14;     /* Change this */
    /* etc... */
}
```

After editing, re-run the installer or manually copy the file and clear cache.

---

## 📝 Technical Details

### Files Modified

- **wrapper.blade.php**: Adds CSS link, watermark, particles, and footer

### Files Added

- **public/themes/halloween/halloween.css**: Main theme stylesheet

### How It Works

The theme uses CSS with `!important` flags to override Pterodactyl's default Tailwind CSS classes. This allows the theme to work without rebuilding the frontend or modifying core files.

---

## 🔄 Updates

To update the theme:

1. Run the uninstaller
2. Pull latest changes: `git pull`
3. Run the installer again

---

## ⚖️ License

MIT License - Free to use and modify

---

## 👨‍💻 Author

**BERMUDA Pterodactyl Panel**

Created by: dinethnethhsara

---

## ❓ Support

- **Issues**: Report bugs by opening an issue on GitHub
- **Questions**: Check troubleshooting section first

---

## ⚠️ Disclaimer

- This theme is provided as-is with no warranty
- Always keep backups of your Pterodactyl installation
- Test on a staging environment first if possible
- The theme installer creates backups automatically
- Not affiliated with official Pterodactyl project

---

## 🎃 Happy Halloween!

Enjoy your spooky Pterodactyl Panel! 👻

**BERMUDA Pterodactyl Panel**
