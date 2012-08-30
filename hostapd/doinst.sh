config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

config etc/hostapd/hlr_auc_gw.milenage_db.new
config etc/hostapd/hostapd.accept.new
config etc/hostapd/hostapd.conf.new
config etc/hostapd/hostapd.deny.new
config etc/hostapd/hostapd.eap_user.new
config etc/hostapd/hostapd.radius_clients.new
config etc/hostapd/hostapd.sim_db.new
config etc/hostapd/hostapd.vlan.new
config etc/hostapd/hostapd.wpa_psk.new
config etc/hostapd/wired.conf.new
