#!/usr/bin/env bash
set -e

echo "============================================================"
echo " ZN-M2 NOWIFI NOUSB final slim config"
echo " Only keep: passwall / mosdns / lucky / gecoosac / microsocks"
echo " Theme: aurora"
echo "============================================================"

# ============================================================
# 进入 OpenWrt 源码目录
# ============================================================

if [ -n "${OPENWRT_PATH}" ] && [ -d "${OPENWRT_PATH}" ]; then
  cd "${OPENWRT_PATH}"
elif [ -d "./openwrt" ]; then
  cd "./openwrt"
elif [ -f "./scripts/config" ]; then
  cd "."
else
  echo "ERROR: cannot find OpenWrt source directory"
  pwd
  ls -la
  exit 1
fi

if [ ! -x "./scripts/config" ]; then
  echo "ERROR: ./scripts/config not found or not executable"
  ls -la ./scripts || true
  exit 1
fi

chmod +x ./scripts/config || true

disable_pkg() {
  local pkg="$1"
  ./scripts/config --disable "PACKAGE_${pkg}" || true
}

enable_pkg() {
  local pkg="$1"
  ./scripts/config --enable "PACKAGE_${pkg}" || true
}

disable_opt() {
  local opt="$1"
  ./scripts/config --disable "${opt}" || true
}

enable_opt() {
  local opt="$1"
  ./scripts/config --enable "${opt}" || true
}

echo "==== Step 1: disable unwanted LuCI apps ===="

# ============================================================
# 关闭所有不需要的 LuCI 插件
# 保留：
# luci
# luci-app-firewall
# luci-app-passwall
# luci-app-mosdns
# luci-app-lucky
# luci-app-gecoosac
# luci-theme-aurora
# ============================================================

UNWANTED_LUCI_APPS="
accesscontrol
adguardhome
advanced
alist
aria2
argon-config
autoreboot
bandix
bypass
cifs-mount
commands
control-timewol
cpufreq
ddns
ddns-go
diskman
dockerman
docker
easymesh
easytier
eqos
fileassistant
filebrowser
filetransfer
frpc
frps
guest-wifi
hd-idle
homeproxy
ikoolproxy
ipsec-vpnd
istorex
koolproxy
lucky-helper
momo
msd_lite
mwan3
n2n_v2
netdata
netspeedtest
nikki
nlbwmon
oaf
onliner
openclash
openlist
openvpn
openvpn-server
passwall2
poweroff
pppoe-relay
pushbot
qos
ramfree
rclone
samba
samba4
serverchan
shadowsocks-libev
shadowsocksr-libev
smartdns
socat
sqm
ssr-plus
syncdial
timecontrol
timewol
tinyproxy
trojan
ttyd
turboacc
udpxy
unblockmusic
upnp
usb-printer
verysync
vlmcsd
vsftpd
watchcat
wechatpush
wol
wolplus
wrtbwmon
xlnetacc
zerotier
"

for app in ${UNWANTED_LUCI_APPS}; do
  disable_pkg "luci-app-${app}"
  disable_pkg "luci-i18n-${app}-zh-cn"
  disable_pkg "luci-i18n-${app}-zh_Hans"
done

# 一些名字不完全规则的 LuCI 包，额外补刀
EXTRA_UNWANTED_LUCI="
luci-app-daed
luci-app-daed-next
luci-app-dae
luci-app-dae-config
luci-app-passwall_INCLUDE_Haproxy
luci-app-passwall_INCLUDE_Hysteria
luci-app-passwall_INCLUDE_NaiveProxy
luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client
luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server
luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client
luci-app-passwall_INCLUDE_Simple_Obfs
luci-app-passwall_INCLUDE_Trojan_Plus
luci-app-passwall_INCLUDE_Tuic_Client
luci-app-passwall_INCLUDE_V2ray_Plugin
luci-app-passwall_INCLUDE_Xray_Plugin
luci-app-passwall2
luci-i18n-passwall2-zh-cn
luci-app-ssr-plus_INCLUDE_NONE_V2RAY
luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Client
luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Server
luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Client
luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Server
luci-app-ssr-plus_INCLUDE_ShadowsocksR_Libev_Client
luci-app-ssr-plus_INCLUDE_ShadowsocksR_Libev_Server
luci-app-ssr-plus_INCLUDE_Trojan
luci-app-ssr-plus_INCLUDE_Xray
luci-app-ssr-plus_INCLUDE_V2ray
luci-app-ssr-plus_INCLUDE_Kcptun
luci-app-ssr-plus_INCLUDE_NaiveProxy
luci-app-ssr-plus_INCLUDE_Tuic_Client
luci-app-ssr-plus_INCLUDE_Hysteria
"

for pkg in ${EXTRA_UNWANTED_LUCI}; do
  disable_pkg "${pkg}"
done

echo "==== Step 2: disable unwanted proxy/VPN cores ===="

# ============================================================
# 关闭其它代理 / VPN / 内网穿透核心
# 注意：保留 xray-core、sing-box、v2ray-geodata、chinadns-ng、dns2socks、ipt2socks
# 这些是 PassWall 精简可用核心
# ============================================================

UNWANTED_PROXY_VPN="
brook
brook-server
clash
clash-core
clash-meta
clash-premium
dae
daed
daed-next
easy-rsa
easytier
frpc
frps
haproxy
hysteria
hysteria1
hysteria2
kcptun
kcptun-client
kcptun-config
kcptun-server
mia
naiveproxy
n2n
n2n-edge
n2n-supernode
openclash
openvpn-easy-rsa
openvpn-mbedtls
openvpn-openssl
openvpn-wolfssl
shadowsocks-libev-config
shadowsocks-libev-ss-local
shadowsocks-libev-ss-redir
shadowsocks-libev-ss-rules
shadowsocks-libev-ss-server
shadowsocks-rust-sslocal
shadowsocks-rust-ssserver
shadowsocksr-libev-alt
shadowsocksr-libev-server
shadowsocksr-libev-ssr-check
shadowsocksr-libev-ssr-local
shadowsocksr-libev-ssr-redir
shadowsocksr-libev-ssr-server
simple-obfs
simple-obfs-client
simple-obfs-server
softethervpn5-client
softethervpn5-server
softethervpn5-libs
tailscale
trojan
trojan-go
trojan-plus
tuic-client
tuic-server
v2ray-core
v2ray-plugin
wireguard-tools
xray-plugin
zerotier
"

for pkg in ${UNWANTED_PROXY_VPN}; do
  disable_pkg "${pkg}"
done

echo "==== Step 3: disable NAS / storage / downloader apps ===="

# ============================================================
# 关闭 NAS、下载、文件管理、磁盘相关
# ============================================================

UNWANTED_STORAGE="
ariang
aria2
autosamba
automount
blkid
block-mount
cfdisk
cifs-utils
fdisk
fuse-utils
hd-idle
lsblk
mount-utils
ntfs-3g
parted
partx-utils
rclone
rclone-ng
rclone-webui
samba36-server
samba4-libs
samba4-server
smartmontools
transmission-daemon
transmission-web
vsftpd
"

for pkg in ${UNWANTED_STORAGE}; do
  disable_pkg "${pkg}"
done

echo "==== Step 4: disable monitoring / benchmark / tools apps ===="

# ============================================================
# 关闭监控、测速、终端、杂项工具
# ============================================================

UNWANTED_TOOLS="
bandix
bmon
btop
coremark
iperf
iperf3
htop
iftop
iotop
lsof
minicom
mtr
netdata
nlbwmon
nload
qos-scripts
sqm-scripts
sqm-scripts-nss
tcpdump
ttyd
vlmcsd
watchcat
wget-ssl
wrtbwmon
"

for pkg in ${UNWANTED_TOOLS}; do
  disable_pkg "${pkg}"
done

echo "==== Step 5: disable WiFi completely ===="

# ============================================================
# 强制关闭 Wi-Fi
# ============================================================

UNWANTED_WIFI="
ipq-wifi-zn_m2
ipq-wifi-cmiot_ax18
ath11k-firmware-ipq6018
ath11k-firmware-qcn9074
ath10k-firmware-qca9887
ath10k-firmware-qca9888
ath10k-firmware-qca988x
ath10k-firmware-qca9984
hostapd
hostapd-common
hostapd-utils
iw
iw-full
iwinfo
kmod-ath
kmod-ath10k
kmod-ath10k-ct
kmod-ath11k
kmod-ath11k-ahb
kmod-ath11k-pci
kmod-cfg80211
kmod-mac80211
mac80211
wireless-regdb
wifi-scripts
wpad
wpad-basic
wpad-basic-mbedtls
wpad-basic-openssl
wpad-mbedtls
wpad-openssl
wpad-wolfssl
wpad-full
wpad-full-mbedtls
wpad-full-openssl
"

for pkg in ${UNWANTED_WIFI}; do
  disable_pkg "${pkg}"
done

echo "==== Step 6: disable USB completely ===="

# ============================================================
# 强制关闭 USB
# ============================================================

UNWANTED_USB="
kmod-usb-core
kmod-usb2
kmod-usb3
kmod-usb-dwc2
kmod-usb-dwc3
kmod-usb-ehci
kmod-usb-hid
kmod-usb-net
kmod-usb-net-asix
kmod-usb-net-asix-ax88179
kmod-usb-net-cdc-eem
kmod-usb-net-cdc-ether
kmod-usb-net-cdc-mbim
kmod-usb-net-cdc-ncm
kmod-usb-net-huawei-cdc-ncm
kmod-usb-net-ipheth
kmod-usb-net-qmi-wwan
kmod-usb-net-rndis
kmod-usb-net-sierrawireless
kmod-usb-ohci
kmod-usb-printer
kmod-usb-serial
kmod-usb-serial-ch341
kmod-usb-serial-cp210x
kmod-usb-serial-ftdi
kmod-usb-serial-option
kmod-usb-serial-pl2303
kmod-usb-serial-wwan
kmod-usb-storage
kmod-usb-storage-extras
kmod-usb-storage-uas
kmod-usb-uhci
kmod-usb-wdm
kmod-usb-xhci-hcd
kmod-usb-xhci-pci
kmod-usb-xhci-platform
usb-modeswitch
usbutils
usbmuxd
"

for pkg in ${UNWANTED_USB}; do
  disable_pkg "${pkg}"
done

echo "==== Step 7: disable filesystem packages used mainly by USB storage ===="

# ============================================================
# 关闭常见外置存储文件系统
# ============================================================

UNWANTED_FS="
dosfstools
e2fsprogs
exfat-mkfs
exfat-fsck
f2fs-tools
kmod-fs-autofs4
kmod-fs-btrfs
kmod-fs-cifs
kmod-fs-exfat
kmod-fs-ext4
kmod-fs-f2fs
kmod-fs-hfs
kmod-fs-hfsplus
kmod-fs-isofs
kmod-fs-msdos
kmod-fs-nfs
kmod-fs-nfs-common
kmod-fs-nfs-common-rpcsec
kmod-fs-nfs-v3
kmod-fs-nfs-v4
kmod-fs-ntfs
kmod-fs-ntfs3
kmod-fs-vfat
kmod-fs-xfs
kmod-nls-base
kmod-nls-cp437
kmod-nls-cp936
kmod-nls-iso8859-1
kmod-nls-utf8
"

for pkg in ${UNWANTED_FS}; do
  disable_pkg "${pkg}"
done

echo "==== Step 8: disable extra themes ===="

# ============================================================
# 只保留 Aurora 主题
# ============================================================

UNWANTED_THEMES="
luci-theme-argon
luci-theme-argon-mod
luci-theme-bootstrap
luci-theme-design
luci-theme-edge
luci-theme-ifit
luci-theme-material
luci-theme-neobird
luci-theme-netgear
luci-theme-opentomcat
luci-theme-opentopd
luci-theme-opentopd-mod
luci-theme-rosy
"

for pkg in ${UNWANTED_THEMES}; do
  disable_pkg "${pkg}"
done

echo "==== Step 9: disable extra services ===="

# ============================================================
# 关闭其它服务类插件
# ============================================================

UNWANTED_SERVICES="
adguardhome
alist
ddns-scripts
ddns-scripts_aliyun
ddns-scripts_dnspod
ddns-scripts-cloudflare
ddns-scripts-services
ddns-go
docker
dockerd
dockerd-rootless
homeproxy
mwan3
oaf
openlist
smartdns
udpxy
upx
vlmcsd
wol
zerotier
"

for pkg in ${UNWANTED_SERVICES}; do
  disable_pkg "${pkg}"
done

echo "==== Step 10: keep base router functions ===="

# ============================================================
# 保留主路由基础功能
# ============================================================

enable_pkg "luci"
enable_pkg "luci-base"
enable_pkg "luci-app-firewall"
enable_pkg "luci-i18n-base-zh-cn"
enable_pkg "luci-i18n-firewall-zh-cn"
enable_pkg "luci-i18n-opkg-zh-cn"

enable_opt "LUCI_LANG_zh_Hans"

enable_pkg "dnsmasq-full"
enable_pkg "firewall"
enable_pkg "iptables"
enable_pkg "ip6tables"
enable_pkg "ip6tables-extra"
enable_pkg "ip6tables-mod-nat"
enable_pkg "ppp"
enable_pkg "ppp-mod-pppoe"
enable_pkg "odhcp6c"
enable_pkg "odhcpd-ipv6only"
enable_pkg "ipv6helper"

echo "==== Step 11: keep NSS / wired forwarding packages ===="

# ============================================================
# 保留 NSS 和有线转发相关
# ============================================================

enable_pkg "kmod-qca-nss-dp"
enable_pkg "kmod-qca-nss-drv"
enable_pkg "kmod-qca-nss-drv-bridge-mgr"
enable_pkg "kmod-qca-nss-drv-igs"
enable_pkg "kmod-qca-nss-drv-lag-mgr"
enable_pkg "kmod-qca-nss-drv-pppoe"
enable_pkg "kmod-qca-nss-drv-vlan-mgr"
enable_pkg "kmod-nss-ifb"

echo "==== Step 12: keep only requested apps ===="

# ============================================================
# 只保留你需要的插件
# ============================================================

# Aurora 主题
enable_pkg "luci-theme-aurora"
disable_pkg "luci-app-aurora-config"

# PassWall
enable_pkg "luci-app-passwall"
enable_pkg "luci-i18n-passwall-zh-cn"

# PassWall 精简核心
enable_pkg "xray-core"
enable_pkg "sing-box"
enable_pkg "v2ray-geodata"
enable_pkg "geoview"
enable_pkg "chinadns-ng"
enable_pkg "dns2socks"
enable_pkg "ipt2socks"

# PassWall 内部选项：只保留 Xray / SingBox / Geodata / DNS 基础
enable_pkg "luci-app-passwall_INCLUDE_Xray"
enable_pkg "luci-app-passwall_INCLUDE_SingBox"
enable_pkg "luci-app-passwall_INCLUDE_V2ray_Geodata"
enable_pkg "luci-app-passwall_INCLUDE_ChinaDNS_NG"
enable_pkg "luci-app-passwall_INCLUDE_Dns2socks"

disable_pkg "luci-app-passwall_INCLUDE_Haproxy"
disable_pkg "luci-app-passwall_INCLUDE_Hysteria"
disable_pkg "luci-app-passwall_INCLUDE_NaiveProxy"
disable_pkg "luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client"
disable_pkg "luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server"
disable_pkg "luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client"
disable_pkg "luci-app-passwall_INCLUDE_Simple_Obfs"
disable_pkg "luci-app-passwall_INCLUDE_Trojan_Plus"
disable_pkg "luci-app-passwall_INCLUDE_Tuic_Client"
disable_pkg "luci-app-passwall_INCLUDE_V2ray_Plugin"
disable_pkg "luci-app-passwall_INCLUDE_Xray_Plugin"

# MosDNS
enable_pkg "luci-app-mosdns"
enable_pkg "luci-i18n-mosdns-zh-cn"
enable_pkg "mosdns"

# Lucky
enable_pkg "luci-app-lucky"
enable_pkg "luci-i18n-lucky-zh-cn"
enable_pkg "lucky"

# GecoosAC
enable_pkg "luci-app-gecoosac"
enable_pkg "gecoosac"

# microsocks
enable_pkg "microsocks"

echo "==== Step 13: force clean duplicated/known bad packages ===="

# ============================================================
# 这些是你前面日志/需求里明确不需要，最后再补刀一次
# ============================================================

disable_pkg "luci-app-vlmcsd"
disable_pkg "luci-i18n-vlmcsd-zh-cn"
disable_pkg "vlmcsd"

disable_pkg "luci-app-rclone"
disable_pkg "luci-i18n-rclone-zh-cn"
disable_pkg "rclone"
disable_pkg "rclone-ng"
disable_pkg "rclone-webui"

disable_pkg "luci-app-ssr-plus"
disable_pkg "luci-i18n-ssr-plus-zh-cn"
disable_pkg "luci-app-openclash"
disable_pkg "luci-app-homeproxy"
disable_pkg "luci-app-nikki"
disable_pkg "luci-app-momo"
disable_pkg "luci-app-daed"

disable_pkg "luci-app-turboacc"
disable_pkg "luci-i18n-turboacc-zh-cn"
disable_pkg "luci-app-sqm"
disable_pkg "luci-i18n-sqm-zh-cn"
disable_pkg "sqm-scripts"
disable_pkg "sqm-scripts-nss"

disable_pkg "luci-app-openlist"
disable_pkg "luci-i18n-openlist-zh-cn"
disable_pkg "luci-app-samba4"
disable_pkg "luci-i18n-samba4-zh-cn"
disable_pkg "luci-app-hd-idle"
disable_pkg "luci-i18n-hd-idle-zh-cn"

disable_pkg "luci-app-ddns"
disable_pkg "luci-i18n-ddns-zh-cn"
disable_pkg "luci-app-ddns-go"
disable_pkg "luci-i18n-ddns-go-zh-cn"
disable_pkg "luci-app-frpc"
disable_pkg "luci-app-frps"
disable_pkg "luci-app-zerotier"
disable_pkg "luci-app-openvpn"
disable_pkg "luci-app-openvpn-server"
disable_pkg "luci-proto-wireguard"
disable_pkg "wireguard-tools"

disable_pkg "luci-app-netspeedtest"
disable_pkg "luci-app-netdata"
disable_pkg "luci-app-nlbwmon"
disable_pkg "luci-app-wrtbwmon"
disable_pkg "wrtbwmon"
disable_pkg "luci-app-ttyd"
disable_pkg "luci-app-filetransfer"
disable_pkg "luci-app-wol"
disable_pkg "luci-app-wolplus"
disable_pkg "luci-app-timewol"
disable_pkg "luci-app-onliner"
disable_pkg "luci-app-vsftpd"
disable_pkg "luci-app-verysync"
disable_pkg "luci-app-watchcat"
disable_pkg "watchcat"
disable_pkg "luci-app-ramfree"
disable_pkg "luci-app-autoreboot"

# WiFi 最后补刀
disable_pkg "ipq-wifi-zn_m2"
disable_pkg "kmod-ath"
disable_pkg "kmod-ath11k"
disable_pkg "kmod-ath11k-ahb"
disable_pkg "kmod-ath11k-pci"
disable_pkg "ath11k-firmware-ipq6018"
disable_pkg "kmod-cfg80211"
disable_pkg "kmod-mac80211"
disable_pkg "mac80211"
disable_pkg "wifi-scripts"
disable_pkg "wireless-regdb"
disable_pkg "iw"
disable_pkg "iwinfo"
disable_pkg "wpad"
disable_pkg "wpad-basic"
disable_pkg "wpad-basic-mbedtls"
disable_pkg "wpad-basic-openssl"
disable_pkg "wpad-openssl"
disable_pkg "wpad-mbedtls"
disable_pkg "wpad-full"
disable_pkg "wpad-full-openssl"
disable_pkg "hostapd"
disable_pkg "hostapd-common"
disable_pkg "hostapd-utils"

# USB 最后补刀
disable_pkg "kmod-usb-core"
disable_pkg "kmod-usb2"
disable_pkg "kmod-usb3"
disable_pkg "kmod-usb-ehci"
disable_pkg "kmod-usb-ohci"
disable_pkg "kmod-usb-xhci-hcd"
disable_pkg "kmod-usb-xhci-pci"
disable_pkg "kmod-usb-storage"
disable_pkg "kmod-usb-storage-uas"
disable_pkg "kmod-usb-net"
disable_pkg "kmod-usb-net-cdc-ether"
disable_pkg "kmod-usb-net-rndis"
disable_pkg "kmod-usb-net-cdc-mbim"
disable_pkg "kmod-usb-net-qmi-wwan"
disable_pkg "kmod-usb-serial"
disable_pkg "kmod-usb-serial-option"
disable_pkg "kmod-usb-serial-wwan"
disable_pkg "usb-modeswitch"
disable_pkg "usbutils"
disable_pkg "usbmuxd"

disable_pkg "block-mount"
disable_pkg "automount"
disable_pkg "autosamba"
disable_pkg "fdisk"
disable_pkg "lsblk"
disable_pkg "blkid"
disable_pkg "e2fsprogs"
disable_pkg "f2fs-tools"
disable_pkg "kmod-fs-ext4"
disable_pkg "kmod-fs-f2fs"
disable_pkg "kmod-fs-vfat"
disable_pkg "kmod-fs-ntfs3"

echo "==== Step 14: run make defconfig again ===="

make defconfig

echo "==== Final enabled requested packages ===="
grep -E '^CONFIG_PACKAGE_(luci-app-passwall|luci-i18n-passwall|luci-app-mosdns|luci-i18n-mosdns|mosdns|luci-app-lucky|luci-i18n-lucky|lucky|luci-app-gecoosac|gecoosac|microsocks|luci-theme-aurora|xray-core|sing-box|v2ray-geodata|geoview|chinadns-ng|dns2socks|ipt2socks)=' .config || true

echo "==== Final enabled LuCI apps ===="
grep -E '^CONFIG_PACKAGE_luci-app-' .config || true

echo "==== Final enabled themes ===="
grep -E '^CONFIG_PACKAGE_luci-theme-' .config || true

echo "==== Check unwanted packages ===="

BAD_PATTERN='^CONFIG_PACKAGE_(luci-app-vlmcsd|vlmcsd|luci-app-rclone|rclone|luci-app-ssr-plus|luci-app-openclash|luci-app-homeproxy|luci-app-nikki|luci-app-momo|luci-app-daed|luci-app-turboacc|luci-app-sqm|luci-app-openlist|luci-app-samba4|luci-app-ddns|luci-app-ddns-go|luci-app-frpc|luci-app-frps|luci-app-zerotier|luci-app-openvpn|luci-proto-wireguard|wireguard-tools|wifi-scripts|kmod-mac80211|kmod-ath11k|kmod-ath11k-ahb|kmod-ath11k-pci|ipq-wifi-zn_m2|wpad|wpad-openssl|hostapd|kmod-usb-core|kmod-usb2|kmod-usb3|kmod-usb-storage|block-mount)='

if grep -E "${BAD_PATTERN}" .config; then
  echo "ERROR: unwanted package still enabled"
  exit 1
fi

echo "==== Check required packages ===="

REQUIRED_PATTERN='^CONFIG_PACKAGE_(luci-app-passwall|luci-app-mosdns|luci-app-lucky|luci-app-gecoosac|microsocks|luci-theme-aurora)='

grep -E "${REQUIRED_PATTERN}" .config || {
  echo "ERROR: required packages missing"
  exit 1
}

echo "============================================================"
echo " ZN-M2 final slim config OK"
echo "============================================================"
