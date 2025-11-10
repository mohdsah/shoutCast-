#!/bin/bash

# Script Auto Remove aaPanel di Ubuntu
# Pastikan dijalankan sebagai root atau dengan sudo

echo "======================================="
echo "   AUTO REMOVE AAPANEL DI UBUNTU"
echo "======================================="

# Fungsi untuk mengecek apakah user root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Error: Script ini harus dijalankan sebagai root atau dengan sudo"
        exit 1
    fi
}

# Fungsi utama remove aaPanel
remove_aapanel() {
    echo "[1/6] Menghentikan service aaPanel..."
    systemctl stop aapanel 2>/dev/null
    systemctl disable aapanel 2>/dev/null
    
    echo "[2/6] Menghapus file dan direktori aaPanel..."
    # Hapus direktori instalasi
    rm -rf /www
    rm -rf /usr/local/aapanel
    rm -rf /opt/aapanel
    
    echo "[3/6] Menghapus service dan systemd unit..."
    rm -f /etc/systemd/system/aapanel.service
    rm -f /lib/systemd/system/aapanel.service
    rm -f /etc/init.d/aapanel
    
    echo "[4/6] Menghapus file konfigurasi..."
    rm -rf /etc/aapanel
    rm -f /etc/profile.d/aapanel.sh
    rm -rf /root/.aapanel
    rm -rf /home/*/.aapanel
    
    echo "[5/6] Menghapus cron jobs..."
    # Hapus cron jobs yang terkait aaPanel
    crontab -l | grep -v aapanel | crontab -
    rm -f /etc/cron.d/aapanel
    rm -f /var/spool/cron/crontabs/root
    
    echo "[6/6] Membersihkan systemd dan reload..."
    systemctl daemon-reload
    systemctl reset-failed
    
    echo "✅ aaPanel berhasil dihapus!"
}

# Fungsi untuk menghapus dependencies (opsional)
remove_dependencies() {
    read -p "Hapus dependencies yang terkait? (nginx/mysql/php) [y/N]: " answer
    if [[ $answer =~ ^[Yy]$ ]]; then
        echo "Menghapus dependencies..."
        apt-get remove --purge -y nginx mysql-server php*
        apt-get autoremove -y
        apt-get clean
    fi
}

# Fungsi untuk menghapus firewall rules
remove_firewall_rules() {
    echo "Menghapus firewall rules aaPanel..."
    # Hapus UFW rules
    ufw delete allow 7800/tcp 2>/dev/null
    ufw delete allow 7880/tcp 2>/dev/null
    ufw delete allow 7881/tcp 2>/dev/null
    ufw delete allow 7882/tcp 2>/dev/null
    ufw delete allow 7883/tcp 2>/dev/null
    
    # Hapus iptables rules
    iptables -D INPUT -p tcp --dport 7800 -j ACCEPT 2>/dev/null
    iptables -D INPUT -p tcp --dport 7880 -j ACCEPT 2>/dev/null
    iptables -D INPUT -p tcp --dport 7881 -j ACCEPT 2>/dev/null
    iptables -D INPUT -p tcp --dport 7882 -j ACCEPT 2>/dev/null
    iptables -D INPUT -p tcp --dport 7883 -j ACCEPT 2>/dev/null
}

# Main execution
main() {
    check_root
    
    echo "Peringatan: Tindakan ini akan menghapus aaPanel dan data terkait!"
    read -p "Apakah Anda yakin ingin melanjutkan? [y/N]: " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        remove_firewall_rules
        remove_aapanel
        remove_dependencies
        
        echo ""
        echo "======================================="
        echo "   PENGHAPUSAN AAPANEL SELESAI"
        echo "======================================="
        echo "✅ Semua file aaPanel telah dihapus"
        echo "✅ Service telah dihentikan dan dihapus"
        echo "✅ Konfigurasi telah dibersihkan"
        echo ""
        echo "Disarankan untuk reboot system: reboot"
    else
        echo "Penghapusan dibatalkan."
    fi
}

# Jalankan script
main