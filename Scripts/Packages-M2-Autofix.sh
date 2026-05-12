#!/usr/bin/env bash
set -e

echo "==> ZN-M2: 自动修复 sysupgrade 校验兼容名 zn,m2"

python3 - <<'PY'
from pathlib import Path

p = Path("target/linux/qualcommax/image/ipq60xx.mk")
if not p.exists():
    print(f"skip: {p} not found")
    raise SystemExit(0)

s = p.read_text(encoding="utf-8")

if "define Device/cmiot_ax18" not in s:
    print("skip: Device/cmiot_ax18 block not found")
    raise SystemExit(0)

if "SUPPORTED_DEVICES += zn,m2" in s:
    print("already patched: SUPPORTED_DEVICES += zn,m2")
    raise SystemExit(0)

old = """define Device/cmiot_ax18
\t$(call Device/FitImage)
\t$(call Device/UbiFit)
\tDEVICE_VENDOR := CMIOT
\tDEVICE_MODEL := AX18
\tBLOCKSIZE := 128k
\tPAGESIZE := 2048
\tDEVICE_DTS_CONFIG := config@cp03-c1
\tSOC := ipq6000
endef
"""

new = """define Device/cmiot_ax18
\t$(call Device/FitImage)
\t$(call Device/UbiFit)
\tDEVICE_VENDOR := CMIOT
\tDEVICE_MODEL := AX18
\tBLOCKSIZE := 128k
\tPAGESIZE := 2048
\tDEVICE_DTS_CONFIG := config@cp03-c1
\tSOC := ipq6000
\tSUPPORTED_DEVICES += zn,m2
endef
"""

if old in s:
    s = s.replace(old, new, 1)
    p.write_text(s, encoding="utf-8")
    print("patched exact block:", p)
else:
    marker = "\tSOC := ipq6000\nendef\nTARGET_DEVICES += cmiot_ax18"
    if marker in s:
        s = s.replace(
            "\tSOC := ipq6000\nendef\nTARGET_DEVICES += cmiot_ax18",
            "\tSOC := ipq6000\n\tSUPPORTED_DEVICES += zn,m2\nendef\nTARGET_DEVICES += cmiot_ax18",
            1
        )
        p.write_text(s, encoding="utf-8")
        print("patched fallback marker:", p)
    else:
        print("skip: no known patch pattern matched")
PY

cd "$(dirname "$0")/.." 2>/dev/null || true
cd openwrt 2>/dev/null || true

echo "==> ZN-M2: 清理冲突包和多余代理核心"

mkdir -p package

rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/themes/luci-theme-aurora
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/sing-box
rm -rf feeds/packages/net/chinadns-ng
rm -rf feeds/packages/net/dns2socks
rm -rf feeds/packages/net/ipt2socks
rm -rf feeds/packages/net/microsocks
rm -rf feeds/packages/net/geoview
rm -rf feeds/packages/net/naiveproxy
rm -rf feeds/packages/net/hysteria
rm -rf feeds/packages/net/trojan-plus
rm -rf feeds/packages/net/tuic-client
rm -rf feeds/packages/net/shadowsocks-rust
rm -rf feeds/packages/net/shadowsocksr-libev
rm -rf feeds/packages/net/simple-obfs
rm -rf feeds/packages/net/v2ray-plugin
rm -rf feeds/packages/net/xray-plugin

find ./ | grep Makefile | grep '/mosdns/' | xargs -r rm -f || true
find ./ | grep Makefile | grep 'v2ray-geodata' | xargs -r rm -f || true

rm -rf package/passwall-packages
rm -rf package/passwall-luci
rm -rf package/mosdns
rm -rf package/v2ray-geodata
rm -rf package/luci-theme-aurora
rm -rf package/luci-app-lucky
rm -rf package/lucky
rm -rf package/luci-app-gecoosac
rm -rf package/gecoosac
rm -rf package/_tmp_lucky
rm -rf package/_tmp_gecoosac

echo "==> ZN-M2: 拉取 PassWall 官方源"
git clone --depth=1 -b main https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/passwall-packages
git clone --depth=1 -b main https://github.com/Openwrt-Passwall/openwrt-passwall.git package/passwall-luci

echo "==> ZN-M2: 拉取 MosDNS"
git clone --depth=1 -b v5 https://github.com/sbwml/luci-app-mosdns.git package/mosdns
git clone --depth=1 https://github.com/sbwml/v2ray-geodata.git package/v2ray-geodata

echo "==> ZN-M2: 拉取 Lucky"
git clone --depth=1 -b main https://github.com/sirpdboy/luci-app-lucky.git package/_tmp_lucky
mv package/_tmp_lucky/luci-app-lucky package/
mv package/_tmp_lucky/lucky package/
rm -rf package/_tmp_lucky

echo "==> ZN-M2: 拉取 gecoosac"
git clone --depth=1 -b main https://github.com/laipeng668/luci-app-gecoosac.git package/_tmp_gecoosac
mv package/_tmp_gecoosac/luci-app-gecoosac package/
mv package/_tmp_gecoosac/gecoosac package/
rm -rf package/_tmp_gecoosac

echo "==> ZN-M2: 拉取 Aurora 主题"
git clone --depth=1 -b master https://github.com/eamonxg/luci-theme-aurora.git package/luci-theme-aurora

echo "==> ZN-M2: 第三方插件源准备完成"
