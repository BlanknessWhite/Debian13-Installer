cat > /root/preseed.cfg <<'EOF'
### 设置基本信息
d-i debian-installer/language string en
d-i debian-installer/country string US
d-i debian-installer/locale string en_US.UTF-8
d-i debian-installer/keymap select us

### 主机名与域名
d-i netcfg/get_hostname string US
d-i netcfg/get_domain string localdomain

### 网络自动配置
d-i netcfg/choose_interface select auto
d-i netcfg/get_nameservers string 1.0.0.1 1.1.1.1

### 时区
d-i time/zone string America/Los_Angeles
d-i clock-setup/utc boolean true
d-i clock-setup/ntp boolean true

### Root 密码
d-i passwd/root-password password Homo114514@
d-i passwd/root-password-again password Homo114514@

### 禁用普通用户
d-i passwd/make-user boolean false

### 磁盘分区（全盘自动覆盖）
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/disk string /dev/sda
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

### APT 源（Debian 13 官方源）
d-i mirror/country string manual
d-i mirror/http/hostname string deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string
d-i apt-setup/services-select multiselect
d-i apt-setup/use_mirror boolean true
d-i apt-setup/security_host string security.debian.org

### 软件
tasksel tasksel/first multiselect standard, ssh-server

### 引导安装
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true

### 安装完成后自动重启
d-i finish-install/reboot_in_progress note

EOF
