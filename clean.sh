#!/bin/bash

echo
echo "🔧 Cleaning package cache..."
sudo apt clean

echo
echo "🧽 Removing unnecessary packages..."
sudo apt autoremove -y

echo
echo "📦 Removing old downloaded package files..."
sudo apt autoclean

echo
echo "🖥️ Showing current kernel version..."
uname -r

echo
echo "🗑️ Removing old kernels (excluding current)..."
current_kernel=$(uname -r | cut -d'-' -f1,2)

dpkg --list | grep 'linux-image-[0-9]' | awk '{ print $2 }' | grep -v "$current_kernel" | xargs sudo apt -y purge

echo
echo "🧵 Removing old kernel headers (excluding current)..."
dpkg --list | grep 'linux-headers-[0-9]' | awk '{ print $2 }' | grep -v "$current_kernel" | xargs sudo apt -y purge

echo
echo "📊 Checking large directories in /var..."
sudo du -h /var --max-depth=1 | sort -hr | head -n 10

echo
echo "🗂️ Finding large files (>100MB)..."
sudo find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | sort -k 5 -rh | head -n 20

echo
echo "🧹 Clearing thumbnail cache..."
rm -rf ~/.cache/thumbnails/*

echo
echo "🧼 Clearing journal logs older than 7 days..."
sudo journalctl --vacuum-time=7d

echo
echo "✅ Cleanup complete."
