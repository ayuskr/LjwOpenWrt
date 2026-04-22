#!/usr/bin/env bash
set -e

echo "==> ZN-M2: 拉取 PassWall / MosDNS / Lucky / gecoosac"

# 进入 OpenWrt 根目录时，工作目录通常已在源码根目录
mkdir -p package

# 1) 先清理会冲突的旧包
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/net/xray-core        feeds/packages/net/v2ray-geodata        feeds/packages/net/sing-box        feeds/packages/net/chinadns-ng        feeds/packages/net/dns2socks        feeds/packages/net/hysteria        feeds/packages/net/ipt2socks        feeds/packages/net/microsocks        feeds/packages/net/naiveproxy        feeds/packages/net/shadowsocks-libev        feeds/packages/net/shadowsocks-rust        feeds/packages/net/shadowsocksr-libev        feeds/packages/net/simple-obfs        feeds/packages/net/tcping        feeds/packages/net/trojan-plus        feeds/packages/net/tuic-client        feeds/packages/net/v2ray-plugin        feeds/packages/net/xray-plugin        feeds/packages/net/geoview        feeds/packages/net/shadow-tls

find ./ | grep Makefile | grep '/mosdns/' | xargs -r rm -f || true
find ./ | grep Makefile | grep 'v2ray-geodata' | xargs -r rm -f || true

rm -rf package/passwall-packages        package/passwall-luci        package/mosdns        package/v2ray-geodata        package/_tmp_lucky        package/_tmp_gecoosac        package/luci-app-lucky        package/lucky        package/luci-app-gecoosac        package/gecoosac

# 2) 拉 PassWall 官方源
git clone --depth=1 -b main https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/passwall-packages
git clone --depth=1 -b main https://github.com/Openwrt-Passwall/openwrt-passwall.git package/passwall-luci

# 3) 拉 MosDNS 官方推荐 v5 分支
git clone --depth=1 -b v5 https://github.com/sbwml/luci-app-mosdns.git package/mosdns
git clone --depth=1 https://github.com/sbwml/v2ray-geodata.git package/v2ray-geodata

# 4) 拉 Lucky
git clone --depth=1 -b main https://github.com/sirpdboy/luci-app-lucky.git package/_tmp_lucky
mv package/_tmp_lucky/luci-app-lucky package/
mv package/_tmp_lucky/lucky package/
rm -rf package/_tmp_lucky

# 5) 拉 gecoosac
git clone --depth=1 -b main https://github.com/laipeng668/luci-app-gecoosac.git package/_tmp_gecoosac
mv package/_tmp_gecoosac/luci-app-gecoosac package/
mv package/_tmp_gecoosac/gecoosac package/
rm -rf package/_tmp_gecoosac

echo "==> ZN-M2: 第三方插件源准备完成"
