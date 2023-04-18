#!/system/bin/sh

if [ $3 = "disable" ]; then
  if [ $1 = "n" ]; then
    killall cc.sh
    echo 3900000 > /sys/class/power_supply/sm7250_bms/constant_charge_current_max
    echo 0 > /sys/class/power_supply/sm7250_bms/charge_disable
    su -lp 2000 -c "cmd notification post -S bigtext -t 'Pixel5-CC' 'System' 'Charge Controller disabled!'"
  elif [ $1 = "d" ]; then
    ${0%/*}/cc.sh &
    su -lp 2000 -c "cmd notification post -S bigtext -t 'Pixel5-CC' 'System' 'Charge Controller enabled!'"
  fi
fi
