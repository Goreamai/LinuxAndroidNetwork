#!/system/bin/sh
set -u

echo "== binaries =="
for path in /system/bin/ssh /system/bin/wpa_supplicant /system/bin/wcnd \
    /system/bin/ip /system/bin/getprop /system/bin/lsmod
do
    if [ -e "$path" ]; then
        echo "$path"
    fi
done
echo "== properties =="
/system/bin/getprop | /system/bin/grep -E 'wcn|wifi|board|device|model' || :
echo "== modules =="
/system/bin/lsmod 2>/dev/null || :
echo "== firmware names =="
/system/bin/find /system/etc/firmware /vendor/firmware /productinfo \
    -maxdepth 1 -type f 2>/dev/null | /system/bin/grep -E 'sc2331|connectivity|wifi' || :
echo "== WCN nodes =="
/system/bin/ls -l /dev/cpwcn /dev/stty_wcn /dev/slog_wcn /dev/spipe_wcn* 2>/dev/null || :
echo "== interfaces =="
/system/bin/ip link 2>/dev/null || :
