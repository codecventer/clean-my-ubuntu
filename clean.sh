#!/bin/bash

# Exit on error
set -e

# Function to print status
print_status() {
    echo "$1"
}

# Function to safely remove if exists
safe_remove() {
    [ -e "$1" ] && rm -rf "$1" && print_status "Removed: $1"
}

print_status "🔧 Starting system cleanup..."

# Package management cleanup (requires manual sudo)
print_status "📦 Package cleanup commands (run manually with sudo):"
print_status "  sudo apt clean && sudo apt autoremove -y && sudo apt autoclean"

# Kernel cleanup (requires manual sudo)
print_status "🗑️ Old kernel removal (run manually with sudo):"
current_kernel=$(uname -r | cut -d'-' -f1,2)
old_kernels=$(dpkg --list | awk '/^ii.*linux-(image|headers)-[0-9]/ {print $2}' | grep -v "$current_kernel" || true)
[ -n "$old_kernels" ] && print_status "  sudo apt -y purge $old_kernels" || print_status "  No old kernels to remove"

# System cache cleanup
print_status "🧹 Clearing system caches..."
safe_remove ~/.cache/thumbnails
safe_remove ~/.cache/mozilla
safe_remove ~/.cache/google-chrome
safe_remove ~/.cache/chromium
safe_remove ~/.cache/microsoft-edge
safe_remove ~/.cache/opera
safe_remove ~/.cache/pip
safe_remove ~/.npm/_cacache
safe_remove ~/.yarn/cache
safe_remove ~/.cache/fontconfig
safe_remove ~/.cache/mesa_shader_cache
safe_remove ~/.cache/nvidia
safe_remove ~/.cache/gstreamer-1.0
safe_remove ~/.cache/evolution
safe_remove ~/.cache/thunderbird

# Temporary files
print_status "🗂️ Cleaning temporary files..."
print_status "System temp cleanup (run manually): sudo rm -rf /tmp/* /var/tmp/*"
safe_remove ~/.local/share/Trash/files
safe_remove ~/.local/share/Trash/info
safe_remove ~/.local/share/recently-used.xbel
safe_remove ~/.xsession-errors
safe_remove ~/.xsession-errors.old
safe_remove ~/.bash_history.old
safe_remove ~/.viminfo
safe_remove ~/.lesshst

# Log cleanup
print_status "📋 Log cleanup commands (run manually with sudo):"
print_status "  sudo journalctl --vacuum-time=7d"
print_status "  sudo find /var/log -name '*.log' -type f -mtime +30 -delete"
print_status "  sudo find /var/log -name '*.gz' -type f -delete"

# Development cleanup
print_status "💻 Cleaning development caches..."
# Java/JVM ecosystem
safe_remove ~/.gradle/caches
safe_remove ~/.gradle/.tmp
safe_remove ~/.m2/repository
safe_remove ~/.ivy2/cache
safe_remove ~/.sbt/boot
safe_remove ~/.sbt/1.0/staging

# Node.js ecosystem
safe_remove ~/.npm/_cacache
safe_remove ~/.nvm/.cache
safe_remove ~/.local/share/pnpm/store
safe_remove ~/.yarn/cache
safe_remove ~/.pnpm-store

# JetBrains IDEs
safe_remove ~/.local/share/JetBrains/*/system/caches
safe_remove ~/.local/share/JetBrains/*/system/logs
safe_remove ~/.local/share/JetBrains/*/system/tmp
safe_remove ~/.local/share/JetBrains/*/system/index
safe_remove ~/.cache/JetBrains

# VS Code
safe_remove ~/.vscode/logs
safe_remove ~/.vscode/CachedExtensions
safe_remove ~/.config/Code/logs
safe_remove ~/.config/Code/CachedData

# AWS Tools
safe_remove ~/.aws/amazonq/cache
safe_remove ~/.aws/sso/cache
safe_remove ~/.aws/cli/cache

# Other development tools
safe_remove ~/.cargo/registry/cache
safe_remove ~/.rustup/toolchains/*/share/doc
safe_remove ~/.go/pkg/mod/cache
safe_remove ~/.composer/cache
safe_remove ~/.nuget/packages
safe_remove ~/.dotnet/NuGetFallbackFolder
safe_remove ~/.gem/specs
safe_remove ~/.bundle/cache
safe_remove ~/.pub-cache
safe_remove ~/.flutter/.pub-cache
safe_remove ~/.android/cache
safe_remove ~/.android/avd/*.avd/cache
safe_remove ~/.local/share/code-server/logs

# Docker cleanup (if installed)
if command -v docker &> /dev/null; then
    print_status "🐳 Cleaning Docker..."
    docker system prune -f 2>/dev/null || true
fi

# Snap cleanup (if installed)
if command -v snap &> /dev/null; then
    print_status "📱 Snap cleanup commands (run manually with sudo):"
    snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
        print_status "  sudo snap remove '$snapname' --revision='$revision'"
    done
fi

# Flatpak cleanup (if installed)
if command -v flatpak &> /dev/null; then
    print_status "📦 Cleaning Flatpak..."
    flatpak uninstall --unused -y 2>/dev/null || true
fi

# Additional Ubuntu-specific cleanup
print_status "🐧 Ubuntu-specific cleanup..."
safe_remove ~/.local/share/zeitgeist
safe_remove ~/.local/share/gvfs-metadata
safe_remove ~/.local/share/baloo
safe_remove ~/.kde/share/apps/nepomuk
safe_remove ~/.thumbnails
safe_remove ~/.macromedia
safe_remove ~/.adobe
safe_remove ~/.wine/drive_c/windows/Temp
safe_remove ~/.steam/logs
safe_remove ~/.steam/dumps

# LibreOffice cleanup
print_status "📄 LibreOffice cleanup..."
safe_remove ~/.config/libreoffice/*/user/backup
safe_remove ~/.config/libreoffice/*/user/temp

# System documentation (safe to remove)
print_status "📚 Documentation cleanup commands (run manually with sudo):"
print_status "  sudo rm -rf /usr/share/doc/*/examples"
print_status "  sudo rm -rf /usr/share/doc/*/changelog*"
print_status "  sudo rm -rf /usr/share/man/*/man*/*.gz"

# Old configuration backups
print_status "⚙️ Cleaning old config backups..."
find ~ -name "*.bak" -type f -mtime +30 -delete 2>/dev/null || true
find ~ -name "*~" -type f -mtime +7 -delete 2>/dev/null || true
find ~ -name "#*#" -type f -delete 2>/dev/null || true

# Show current cache sizes before cleanup
print_status "📊 Current development cache sizes:"
print_status "JetBrains: $(du -sh ~/.local/share/JetBrains 2>/dev/null | cut -f1 || echo '0B')"
print_status "Maven: $(du -sh ~/.m2 2>/dev/null | cut -f1 || echo '0B')"
print_status "Gradle: $(du -sh ~/.gradle 2>/dev/null | cut -f1 || echo '0B')"
print_status "npm: $(du -sh ~/.npm 2>/dev/null | cut -f1 || echo '0B')"
print_status "nvm: $(du -sh ~/.nvm 2>/dev/null | cut -f1 || echo '0B')"
print_status "AWS: $(du -sh ~/.aws 2>/dev/null | cut -f1 || echo '0B')"
print_status "VS Code: $(du -sh ~/.vscode 2>/dev/null | cut -f1 || echo '0B')"

# Show largest directories for manual review
print_status "📊 Largest directories (review manually):"
du -h ~ --max-depth=2 2>/dev/null | sort -hr | head -10 || true

# Show disk usage summary
print_status "💾 Disk usage summary:"
df -h / | tail -1

print_status "✅ Cleanup complete!"
