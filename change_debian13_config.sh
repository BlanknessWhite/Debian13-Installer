#!/bin/bash
set -e

ISO_URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.0.0-amd64-netinst.iso"
ISO_PATH="/root/debian13.iso"
PRESEED_PATH="/root/preseed.cfg"

echo "[1/4] 下载 Debian 13 netinst ISO..."
wget -O "$ISO_PATH" "$ISO_URL"

echo "[2/4] 安装必要引导工具..."
apt update
apt install -y grub2-common grub-pc-bin kexec-tools

echo "[3/4] 配置 GRUB 以一次性从 ISO 启动..."
cat > /etc/grub.d/40_custom <<EOF
menuentry "Install Debian 13 (Unattended)" {
    set isofile="$ISO_PATH"
    loopback loop (hd0,1)\$isofile
    linux (loop)/install.amd/vmlinuz auto=true priority=critical url=file://$PRESEED_PATH
    initrd (loop)/install.amd/initrd.gz
}
EOF

update-grub

echo "[4/4] 设置下一次重启进入安装程序..."
echo "系统将立即重启，开始无人值守 Debian 13 安装（会覆盖整个 /dev/sda）"
sleep 5
reboot
