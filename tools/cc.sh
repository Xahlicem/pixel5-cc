#!/system/bin/sh
#CONSTANTS
level_stp=60
level_res=40
#PATHS
path_plug="/sys/class/power_supply/sm7250_bms/online"
path_batt="/sys/class/power_supply/battery/capacity"
path_stop="/sys/class/power_supply/sm7250_bms/charge_disable"
path_amps="/sys/class/power_supply/sm7250_bms/constant_charge_current_max"
#ALIAS
alias plug='[ "$(cat $path_plug)" -eq 1 ]'
alias batt_low='[ "$(cat $path_batt)" -lt $level_res ]'
alias batt_mid='[ "$(cat $path_batt)" -lt $level_stp ]'
alias batt_high='[ "$(cat $path_batt)" -gt $level_stp ]'
#VARIABLES
nfc_flag=false
#FUNCTIONS
nfc() {
  local mState=$(dumpsys nfc | grep "mState=")
  if [ $mState = "mState=off" ] && $nfc_flag; then
    nfc_flag=false
    echo "Controller Enabled"
  elif [ $mState = "mState=on" ] && ! $nfc_flag; then
    echo 3900000 > $path_amps
    echo 0 > $path_stop
    su -lp 2000 -c "cmd notification post -S bigtext -t 'Pixel5-CC' 'System' 'Phone will charge normally until NFC is disabled.'"
    nfc_flag=true
    echo "Controller Disabled"
  fi
}

plug_wait() {
  nfc
  if ! plug || $nfc_flag; then
    return
  fi
  sleep 1
}

charge() {
  echo $1 > $path_stop
  if [ $1 -eq 1 ]; then
    echo "Stop"
    while ! batt_low && ! $nfc_flag; do
      plug_wait
    done
  else
    echo "Charge"
    echo 500000 > $path_amps
    while batt_mid && ! $nfc_flag; do
      plug_wait
    done
  fi
}
#MAIN
while true; do
  nfc
  if plug && ! $nfc_flag; then
    if batt_low; then
      charge 0
    else
      charge 1
    fi
  fi
  sleep 5
done
