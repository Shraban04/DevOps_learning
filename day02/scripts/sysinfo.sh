#!/bin/bash
# ==============================================
# sysinfo.sh — System Information Script
# Author: Your Name
# Date: Today's Date
# ==============================================
echo "============================================"
echo "         SYSTEM INFORMATION REPORT"
echo "============================================"
echo ""
echo "--- HOSTNAME & USER ---"
echo "Hostname:    $(hostname)"
echo "Username:    $(whoami)"
echo "Date/Time:   $(date)"
echo ""
echo "--- OPERATING SYSTEM ---"
echo "OS Info:"
cat /etc/os-release | grep -E "^(NAME|VERSION)=" | sed 's/"//g'
echo "Kernel:      $(uname -r)"
echo ""
echo "--- CPU INFORMATION ---"
echo "CPU Model:   $(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)"
echo "CPU Cores:   $(nproc)"
echo ""
echo "--- MEMORY USAGE ---"
free -h | awk 'NR==2{printf "Total: %s | Used: %s | Free: %s | Usage: %.2f%%\n", $2, $3, $4, $3/$2*100}'
echo ""
echo "--- DISK USAGE ---"
df -h | grep -v tmpfs | grep -v udev
echo ""
echo "--- TOP 5 CPU PROCESSES ---"
ps aux --sort=-%cpu | head -6 | awk '{printf "%-20s %5s %5s\n", $11, $3, $4}' | head -6
echo ""
echo "--- NETWORK INTERFACES ---"
ip addr show | grep -E "^[0-9]+:|inet " | grep -v "127.0.0.1"
echo ""
echo "--- LAST 5 SYSTEM LOGINS ---"
last | head -5
echo ""
echo "--- LISTENING PORTS ---"
ss -tulnp 2>/dev/null || netstat -tulnp 2>/dev/null
echo ""
echo "--- RECENTLY MODIFIED FILES (last 10) ---"
find /var/log -type f -mmin -60 2>/dev/null | head -10
echo ""
echo "--- FAILED LOGIN ATTEMPTS ---"
grep "Failed password" /var/log/auth.log 2>/dev/null | tail -5 || echo "Log not accessible"
echo ""
echo "============================================"
echo "       Report generated at $(date)"
echo "============================================"
