#!/usr/bin/env bash
set -e

echo "==== ZN-M2 final slim config after defconfig ===="

cd "${OPENWRT_PATH:-./openwrt}" 2>/dev/null || cd openwrt

# ============================================================
# 强制关闭不需要的插件
# ============================================================

./scripts/config --disable PACKAGE_luci-app-vlmcsd
./scripts/config --disable PACKAGE_luci-i18n-vlmcsd-zh-cn
./scripts/config --disable PACKAGE_vlmcsd

./scripts/config --disable PACKAGE_luci-app-rclone
./scripts/config --disable PACKAGE_luci-i18n-rclone-zh-cn
./scripts/config --disable PACKAGE_rclone
./scripts/config --disable PACKAGE_rclone-ng
./scripts/config --disable PACKAGE_rclone-webui

./scripts/config --disable PACKAGE_luci-app-ssr-plus
./scripts/config --disable PACKAGE_luci-i18n-ssr-plus-zh-cn
./scripts/config --disable PACKAGE_luci-app-openclash
./scripts/config --disable PACKAGE_luci-app-homeproxy
./scripts/config --disable PACKAGE_luci-app-nikki
./scripts/config --disable PACKAGE_luci-app-momo
./scripts/config --disable PACKAGE_luci-app-daed

./scripts/config --disable PACKAGE_luci-app-autoreboot
./scripts/config --disable PACKAGE_luci-i18n-autoreboot-zh-cn
./scripts/config --disable PACKAGE_luci-app-ramfree
./scripts/config --disable PACKAGE_luci-i18n-ramfree-zh-cn
./scripts/config --disable PACKAGE_luci-app-watchcat
./scripts/config --disable PACKAGE_luci-i18n-watchcat-zh-cn
./scripts/config --disable PACKAGE_watchcat

./scripts/config --disable PACKAGE_luci-app-samba
./scripts/config --disable PACKAGE_luci-app-samba4
./scripts/config --disable PACKAGE_luci-i18n-samba4-zh-cn
./scripts/config --disable PACKAGE_luci-app-openlist
./scripts/config --disable PACKAGE_luci-i18n-openlist-zh-cn
./scripts/config --disable PACKAGE_luci-app-diskman
./scripts/config --disable PACKAGE_luci-app-hd-idle
./scripts/config --disable PACKAGE_luci-i18n-hd-idle-zh-cn

./scripts/config --disable PACKAGE_luci-app-ddns
./scripts/config --disable PACKAGE_luci-i18n-ddns-zh-cn
./scripts/config --disable PACKAGE_luci-app-ddns-go
./scripts/config --disable PACKAGE_luci-i18n-ddns-go-zh-cn
./scripts/config --disable PACKAGE_luci-app-frpc
./scripts/config --disable PACKAGE_luci-app-frps
./scripts/config --disable PACKAGE_luci-app-zerotier
./scripts/config --disable PACKAGE_luci-app-openvpn
./scripts/config --disable PACKAGE_luci-app-openvpn-server
./scripts/config --disable PACKAGE_luci-proto-wireguard
./scripts/config --disable PACKAGE_wireguard-tools

./scripts/config --disable PACKAGE_luci-app-turboacc
./scripts/config --disable PACKAGE_luci-i18n-turboacc-zh-cn
./scripts/config --disable PACKAGE_luci-app-sqm
./scripts/config --disable PACKAGE_sqm-scripts
./scripts/config --disable PACKAGE_sqm-scripts-nss

./scripts/config --disable PACKAGE_luci-app-netspeedtest
./scripts/config --disable PACKAGE_luci-app-netdata
./scripts/config --disable PACKAGE_luci-app-nlbwmon
./scripts/config --disable PACKAGE_luci-app-wrtbwmon
./scripts/config --disable PACKAGE_wrtbwmon
./scripts/config --disable PACKAGE_luci-app-ttyd
./scripts/config --disable PACKAGE_luci-app-filetransfer
./scripts/config --disable PACKAGE_luci-app-wol
./scripts/config --disable PACKAGE_luci-app-wolplus
./scripts/config --disable PACKAGE_luci-app-timewol
./scripts/config --disable PACKAGE_luci-app-onliner
./scripts/config --disable PACKAGE_luci-app-vsftpd
./scripts/config --disable PACKAGE_luci-app-verysync

# ============================================================
# 强制关闭 WiFi
# ============================================================

./scripts/config --disable PACKAGE_ipq-wifi-zn_m2
./scripts/config --disable PACKAGE_kmod-ath
./scripts/config --disable PACKAGE_kmod-ath11k
./scripts/config --disable PACKAGE_kmod-ath11k-ahb
./scripts/config --disable PACKAGE_kmod-ath11k-pci
./scripts/config --disable PACKAGE_ath11k-firmware-ipq6018
./scripts/config --disable PACKAGE_ath11k-firmware-qcn9074
./scripts/config --disable PACKAGE_kmod-cfg80211
./scripts/config --disable PACKAGE_kmod-mac80211
./scripts/config --disable PACKAGE_mac80211
./scripts/config --disable PACKAGE_wifi-scripts
./scripts/config --disable PACKAGE_wireless-regdb
./scripts/config --disable PACKAGE_iw
./scripts/config --disable PACKAGE_iwinfo
./scripts/config --disable PACKAGE_wpad
./scripts/config --disable PACKAGE_wpad-basic
./scripts/config --disable PACKAGE_wpad-basic-mbedtls
./scripts/config --disable PACKAGE_wpad-basic-openssl
./scripts/config --disable PACKAGE_wpad-openssl
./scripts/config --disable PACKAGE_wpad-mbedtls
./scripts/config --disable PACKAGE_wpad-wolfssl
./scripts/config --disable PACKAGE_wpad-full
./scripts/config --disable PACKAGE_wpad-full-openssl
./scripts/config --disable PACKAGE_hostapd
./scripts/config --disable PACKAGE_hostapd-common
./scripts/config --disable PACKAGE_hostapd-utils

# ============================================================
# 强制关闭 USB / 存储
# ============================================================

./scripts/config --disable PACKAGE_kmod-usb-core
./scripts/config --disable PACKAGE_kmod-usb2
./scripts/config --disable PACKAGE_kmod-usb3
./scripts/config --disable PACKAGE_kmod-usb-ehci
./scripts/config --disable PACKAGE_kmod-usb-ohci
./scripts/config --disable PACKAGE_kmod-usb-xhci-hcd
./scripts/config --disable PACKAGE_kmod-usb-xhci-pci
./scripts/config --disable PACKAGE_kmod-usb-storage
./scripts/config --disable PACKAGE_kmod-usb-storage-uas
./scripts/config --disable PACKAGE_kmod-usb-net
./scripts/config --disable PACKAGE_kmod-usb-net-cdc-ether
./scripts/config --disable PACKAGE_kmod-usb-net-rndis
./scripts/config --disable PACKAGE_kmod-usb-net-cdc-mbim
./scripts/config --disable PACKAGE_kmod-usb-net-qmi-wwan
./scripts/config --disable PACKAGE_kmod-usb-serial
./scripts/config --disable PACKAGE_kmod-usb-serial-option
./scripts/config --disable PACKAGE_kmod-usb-serial-wwan
./scripts/config --disable PACKAGE_usb-modeswitch
./scripts/config --disable PACKAGE_usbutils
./scripts/config --disable PACKAGE_usbmuxd

./scripts/config --disable PACKAGE_block-mount
./scripts/config --disable PACKAGE_automount
./scripts/config --disable PACKAGE_autosamba
./scripts/config --disable PACKAGE_fdisk
./scripts/config --disable PACKAGE_lsblk
./scripts/config --disable PACKAGE_blkid
./scripts/config --disable PACKAGE_e2fsprogs
./scripts/config --disable PACKAGE_f2fs-tools
./scripts/config --disable PACKAGE_kmod-fs-ext4
./scripts/config --disable PACKAGE_kmod-fs-f2fs
./scripts/config --disable PACKAGE_kmod-fs-vfat
./scripts/config --disable PACKAGE_kmod-fs-ntfs3

# ============================================================
# 只保留目标插件
# ============================================================

./scripts/config --enable PACKAGE_luci
./scripts/config --enable LUCI_LANG_zh_Hans
./scripts/config --enable PACKAGE_luci-i18n-base-zh-cn
./scripts/config --enable PACKAGE_luci-i18n-firewall-zh-cn
./scripts/config --enable PACKAGE_luci-i18n-opkg-zh-cn

./scripts/config --enable PACKAGE_luci-theme-aurora
./scripts/config --disable PACKAGE_luci-theme-argon
./scripts/config --disable PACKAGE_luci-theme-bootstrap

./scripts/config --enable PACKAGE_luci-app-passwall
./scripts/config --enable PACKAGE_luci-i18n-passwall-zh-cn
./scripts/config --enable PACKAGE_xray-core
./scripts/config --enable PACKAGE_sing-box
./scripts/config --enable PACKAGE_v2ray-geodata
./scripts/config --enable PACKAGE_geoview
./scripts/config --enable PACKAGE_chinadns-ng
./scripts/config --enable PACKAGE_dns2socks
./scripts/config --enable PACKAGE_ipt2socks

./scripts/config --enable PACKAGE_luci-app-mosdns
./scripts/config --enable PACKAGE_luci-i18n-mosdns-zh-cn
./scripts/config --enable PACKAGE_mosdns

./scripts/config --enable PACKAGE_luci-app-lucky
./scripts/config --enable PACKAGE_luci-i18n-lucky-zh-cn
./scripts/config --enable PACKAGE_lucky

./scripts/config --enable PACKAGE_luci-app-gecoosac
./scripts/config --enable PACKAGE_gecoosac

./scripts/config --enable PACKAGE_microsocks

# ============================================================
# 重新生成最终配置
# ============================================================

make defconfig

echo "==== Final enabled target packages ===="
grep -E '^CONFIG_PACKAGE_(luci-app-|luci-theme-|vlmcsd|rclone|wpad|wifi-scripts|kmod-ath11k|kmod-mac80211|kmod-usb|block-mount|microsocks|mosdns|lucky|gecoosac|xray-core|sing-box)=' .config || true

echo "==== Check unwanted packages ===="
if grep -E '^CONFIG_PACKAGE_(luci-app-vlmcsd|vlmcsd|luci-app-rclone|luci-app-ssr-plus|luci-app-openclash|wifi-scripts|kmod-mac80211|kmod-ath11k|wpad|kmod-usb-core|block-mount)=' .config; then
  echo "ERROR: unwanted package still enabled"
  exit 1
fi

echo "==== ZN-M2 final slim config OK ===="
