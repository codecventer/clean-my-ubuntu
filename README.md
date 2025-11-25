# Clean My Ubuntu

This script performs a comprehensive cleanup of a Debian/Ubuntu-based Linux system, helping you free up disk space by removing caches, temporary files, and providing commands for system-level cleanup operations.

> **Note:**  
> This script provides both automated cleanup for user-level caches and manual commands for system-level operations that require sudo privileges.

---

## Features

- **Automated User Cache Cleanup:**
  - Browser caches (Chrome, Firefox, Edge, Opera)
  - Development tool caches (npm, yarn, pip, Gradle, Maven, JetBrains IDEs, VS Code)
  - System caches (thumbnails, fonts, graphics)
  - Temporary files and trash
  - Old configuration backups

- **Manual System Commands:**
  - Package management cleanup (apt clean, autoremove, autoclean)
  - Old kernel removal (safely excludes current kernel)
  - System log cleanup (journalctl, log files)
  - System temporary files cleanup

- **Additional Features:**
  - Docker cleanup (if installed)
  - Snap package cleanup commands (if installed)
  - Flatpak cleanup (if installed)
  - Disk usage analysis and reporting

---

## Usage

1. **Download the Script:**
   ```bash
   wget https://raw.githubusercontent.com/codecventer/clean-my-ubuntu/main/clean.sh
   ```

2. **Make the Script Executable:**
   ```bash
   chmod +x clean.sh
   ```

3. **Run the Script:**
   ```bash
   ./clean.sh
   ```

The script will automatically clean user-level caches and provide commands for system-level cleanup that you can run manually with sudo.

---

## What Gets Cleaned Automatically

### Browser Caches
- `~/.cache/mozilla` (Firefox)
- `~/.cache/google-chrome`
- `~/.cache/chromium`
- `~/.cache/microsoft-edge`
- `~/.cache/opera`

### Development Tool Caches
- **Java/JVM:** Gradle, Maven, Ivy, SBT caches
- **Node.js:** npm, yarn, pnpm caches
- **IDEs:** JetBrains IDEs, VS Code logs and caches
- **Cloud Tools:** AWS CLI/Q caches
- **Other:** Cargo, Go, Composer, NuGet, Ruby gems, Flutter, Android

### System Caches
- Thumbnail caches
- Font caches
- Graphics shader caches
- Audio/video caches

### Temporary Files
- User trash files
- Recently used file lists
- Session error logs
- Editor temporary files

---

## Manual Commands Provided

The script provides ready-to-run commands for operations requiring sudo:

### Package Management
```bash
sudo apt clean && sudo apt autoremove -y && sudo apt autoclean
```

### Old Kernel Removal
The script identifies old kernels and provides the exact command to remove them while preserving the current kernel.

### Log Cleanup
```bash
sudo journalctl --vacuum-time=7d
sudo find /var/log -name '*.log' -type f -mtime +30 -delete
sudo find /var/log -name '*.gz' -type f -delete
```

### System Temporary Files
```bash
sudo rm -rf /tmp/* /var/tmp/*
```

---

## Safety Features

- **Current Kernel Protection:** Automatically excludes the running kernel from removal
- **Error Handling:** Uses `set -e` to exit on errors
- **Safe Removal Function:** Only removes files/directories that exist
- **Manual Sudo Commands:** System-level operations require manual execution for safety

---

## Reporting

The script provides detailed reporting including:
- Current cache sizes for major development tools
- Largest directories in your home folder
- Disk usage summary
- Status messages with emojis for easy reading

---

## Compatibility

- **Operating Systems:** Ubuntu, Debian, and derivatives
- **Package Managers:** APT (primary), with detection for Snap and Flatpak
- **Containerization:** Docker cleanup support
- **Development Environments:** Comprehensive support for popular development tools

---

## Notes & Recommendations

- **Review Before Running:** Check the manual commands before executing them
- **Backup Important Data:** Always backup critical systems before cleanup
- **Kernel Safety:** The script protects your current kernel, but review kernel removal commands on production systems
- **Large Files:** Use the disk usage report to identify additional cleanup opportunities
- **Customization:** Modify the script to add or remove specific cleanup targets for your environment

---

## License

This script is provided as-is, without warranty. Use at your own risk.

---

## Authors

- [@codecventer](https://www.github.com/codecventer)
