#!/system/bin/sh

if [ $3 == "disable" ]; then
  if [ $1 == "n" ]; then
    killall cc
    echo 3900000 > /sys/class/power_supply/sm7250_bms/constant_charge_current_max
    echo 0 > /sys/class/power_supply/sm7250_bms/charge_disable
  elif [ $1 == "d" ]; then
    cc
  fi
fi

