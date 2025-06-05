# Clean My Ubuntu

This script is designed to perform a thorough cleanup of a Debian/Ubuntu-based Linux system, helping you free up disk space, remove unnecessary packages and old kernel versions, and identify large files and directories that may be taking up space. 

> **Warning:**  
> This script uses `sudo` for several commands and removes old kernels, so exercise caution. Make sure you understand each step and have backups for critical systems.

---

## Features

- Cleans the `apt` package cache.
- Removes unneeded packages and old downloaded package files.
- Identifies and purges old Linux kernels and headers (keeping the current kernel).
- Lists the largest directories under `/var`.
- Finds the largest files on the system (>100MB).
- Cleans user thumbnail cache.
- Cleans system journal logs older than 7 days.
- Summarizes actions with user-friendly output and emojis.

---

## Usage

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/codecventer/clean-my-ubuntu.git
   ```

2. **Navigate to the Script Directory:**
   ```bash
   cd clean-my-ubuntu
   ```

3. **Make the Script Executable:**
   ```bash
   chmod +x clean.sh
   ```

4. **Run the Script:**
   ```bash
   ./clean.sh
   ```
   You may need to enter your password for `sudo` commands.

---

## Script Steps Explained

### 1. Cleaning `apt` Package Cache
```bash
sudo apt clean
```
Removes all cached `.deb` package files from `/var/cache/apt/archives`.

---

### 2. Removing Unnecessary Packages
```bash
sudo apt autoremove -y
```
Removes packages that were installed automatically to satisfy dependencies but are no longer needed.

---

### 3. Removing Old Downloaded Package Files
```bash
sudo apt autoclean
```
Removes only obsolete package files from the cache (packages that can no longer be downloaded).

---

### 4. Showing Current Kernel Version
```bash
uname -r
```
Prints the current running kernel version.

---

### 5. Removing Old Kernels (Excluding Current)
```bash
current_kernel=$(uname -r | cut -d'-' -f1,2)
dpkg --list | grep 'linux-image-[0-9]' | awk '{ print $2 }' | grep -v "$current_kernel" | xargs sudo apt -y purge
```
Finds and purges old Linux kernel images, keeping the current one.  
**Note:** Make sure your current kernel is not accidentally removed.

---

### 6. Removing Old Kernel Headers (Excluding Current)
```bash
dpkg --list | grep 'linux-headers-[0-9]' | awk '{ print $2 }' | grep -v "$current_kernel" | xargs sudo apt -y purge
```
Finds and purges old kernel header packages.

---

### 7. Checking Large Directories in `/var`
```bash
sudo du -h /var --max-depth=1 | sort -hr | head -n 10
```
Displays the top 10 largest directories within `/var`, a common place for logs and caches.

---

### 8. Finding Large Files (>100MB)
```bash
sudo find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | sort -k 5 -rh | head -n 20
```
Searches the entire filesystem for files larger than 100MB, then lists the 20 largest.

---

### 9. Clearing Thumbnail Cache
```bash
rm -rf ~/.cache/thumbnails/*
```
Removes cached thumbnails for the current user, which can accumulate over time.

---

### 10. Clearing Journal Logs Older Than 7 Days
```bash
sudo journalctl --vacuum-time=7d
```
Deletes systemd journal logs older than 7 days to free up space.

---

### 11. Completion Message

Prints a final message indicating the cleanup is complete.

---

## Notes & Recommendations

- **Root Privileges:**  
  Several steps require root privileges. Run as a user with `sudo` rights.

- **Kernel Removal:**  
  Double-check kernel removal steps on production systems. Accidentally removing the currently running or only bootable kernel can render the system unbootable.

- **Log Files:**  
  The script does not delete log files directly except through journalctl. You may wish to review `/var/log` for additional space savings.

- **Large Files:**  
  Review the list of large files before deleting anything important.

- **Modifications:**  
  You can customize the script to fit your particular system or distribution if needed.

---

## License

This script is provided as-is, without warranty or guarantee of suitability for any particular purpose. Use at your own risk.

---

## Authors

- [@codecventer](https://www.github.com/codecventer)
