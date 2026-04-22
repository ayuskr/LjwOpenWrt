#!/usr/bin/env bash
set -e

echo "==> ZN-M2: 自动修复 sysupgrade 校验兼容名 (zn,m2)"

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
	$(call Device/FitImage)
	$(call Device/UbiFit)
	DEVICE_VENDOR := CMIOT
	DEVICE_MODEL := AX18
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	DEVICE_DTS_CONFIG := config@cp03-c1
	SOC := ipq6000
endef
"""

new = """define Device/cmiot_ax18
	$(call Device/FitImage)
	$(call Device/UbiFit)
	DEVICE_VENDOR := CMIOT
	DEVICE_MODEL := AX18
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	DEVICE_DTS_CONFIG := config@cp03-c1
	SOC := ipq6000
	SUPPORTED_DEVICES += zn,m2
endef
"""

if old in s:
    s = s.replace(old, new, 1)
    p.write_text(s, encoding="utf-8")
    print("patched exact block:", p)
else:
    marker = "\tSOC := ipq6000\nendef\nTARGET_DEVICES += cmiot_ax18"
    if marker in s:
        s = s.replace("\tSOC := ipq6000\nendef\nTARGET_DEVICES += cmiot_ax18",
                      "\tSOC := ipq6000\n\tSUPPORTED_DEVICES += zn,m2\nendef\nTARGET_DEVICES += cmiot_ax18", 1)
        p.write_text(s, encoding="utf-8")
        print("patched fallback marker:", p)
    else:
        print("skip: no known patch pattern matched")
PY

echo "==> ZN-M2: 拉取 PassWall / MosDNS / Lucky / gecoosac"

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
