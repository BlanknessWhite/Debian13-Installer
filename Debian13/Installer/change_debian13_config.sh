#!/bin/bash
# Debian 13 系统配置脚本（非 Preseed，适用于已安装系统）
# 功能：
# 1. 替换为 Debian 13 官方源
# 2. 配置主机名、时区、DNS、网络静态IP
# 3. 更新系统并安装常用软件

set -e

# 检查是否为 root
if [ "$(id -u)" -ne 0 ]; then
    echo "请以 root 权限运行此脚本"
    exit 1
fi

echo "开始配置 Debian 13 系统..."

### 1. 替换为 Debian 13 官方源
echo "配置 apt 源..."
cat > /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware
EOF

### 2. 配置主机名
echo "配置主机名为 US..."
hostnamectl set-hostname US

### 3. 配置时区
echo "配置时区为 America/Los_Angeles..."
timedatectl set-timezone America/Los_Angeles

### 4. 配置网络为静态IP
echo "配置网络为静态IP..."
IFACE=$(ip route | grep '^default' | awk '{print $5}')
cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto $IFACE
iface $IFACE inet static
    address 38.95.121.180
    netmask 255.255.255.0
    gateway 38.95.121.1
    dns-nameservers 1.0.0.1 1.1.1.1
EOF

### 重启网络服务
if command -v systemctl >/dev/null 2>&1; then
    systemctl restart networking
else
    /etc/init.d/networking restart
fi

### 5. 系统更新与常用包安装
echo "更新系统并安装常用软件..."
apt-get update
apt-get dist-upgrade -y
apt-get install -y sudo vim curl wget net-tools

echo "配置完成，请重启系统使所有变更生效。"
