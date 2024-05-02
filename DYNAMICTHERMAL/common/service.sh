#!/system/bin/sh
MODDIR=${0%/*}

# Reset props after boot completed to avoid breaking some weird devices/ROMs..
write() {
	[[ ! -f "$1" ]] && return 1
	chmod +w "$1" 2> /dev/null
	if ! echo "$2" > "$1" 2> /dev/null
	then
		echo "Failed: $1 → $2"
		return 1
	fi
}

sleep 20

# UFSPerformance
# echo performance > /sys/class/devfreq/1d84000.ufshc/governor

# Force Thermal Dynamic Evaluation
chmod 0777 /sys/class/thermal/thermal_message/sconfig
echo 10 > /sys/class/thermal/thermal_message/sconfig
chmod 0444 /sys/class/thermal/thermal_message/sconfig

# Disable temp* thermal zone
for zone in /sys/class/thermal/thermal_zone*; do
    if [[ -d "$zone" ]]; then
        echo "Disabling temp in $zone"
        chmod a-r "$zone"/temp
    fi
done

# Other commands or settings if required
su -c settings put system miui_app_cache_optimization 1
su -c settings put global touch_response_time 0
su -c settings put global foreground_ram_priority high
su -c settings put global private_dns_mode opportunistic
su -c settings put global smart_network_speed_distribution 1
su -c settings put global use_data_network_accelerate 1
su -c settings put global animator_duration_scale 0.0024999
su -c settings put global transition_animation_scale 0.0024999
su -c settings put global window_animation_scale 0.0024999
su -c cmd power set-fixed-performance-mode-enabled true
su -c cmd thermalservice override-status -1
su -c settings put system power_mode high
#su -c settings put system speed_mode 1
su -c settings put secure speed_mode_enable 1
#su -c settings put secure thermal_temp_state_value 0
su -c settings put system thermal_limit_refresh_rate -1
su -c settings put system link_turbo_option 1
su -c settings put global transition_animation_duration_ratio 0.0024999
su -c settings put global block_untrusted_touches 0

# ข้อความ
su -lp 2000 -c "cmd notification post -S bigtext -t '🔥TWEAK🔥' 'Tag' 'VTEC_Dynamic ⚡ปรับแต่ง⚡ Impover Overall Stability Successfull @RealHard️'"

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port
echo 1 > /sys/kernel/fast_charge/force_fast_charge
exit 0