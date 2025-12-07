#!/bin/bash

# Timezone
timedatectl set-timezone Asia/Tokyo
systemctl restart rsyslog

# Locale
localectl set-locale LANG=ja_JP.utf8
localectl set-keymap jp106

# Package Update
dnf update -y

# Firewall Service disable
systemctl stop firewalld
systemctl disable firewalld
systemctl mask firewalld

# SELinux disable
grubby --update-kernel ALL --args selinux=0
shutdown -r now