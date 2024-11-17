#!/system/bin/sh
MODDIR=${0%/*}

# Optimization
{
while true; do
        resetprop  -n persist.sys.turbosched.enable true
        resetprop  -n persist.sys.turbosched.enable.coreApp.optimizer true
        resetprop  -n -p --delete persist.log.tag.LSPosed
        resetprop  -n -p --delete persist.log.tag.LSPosed-Bridge
        sleep 1;
    done
} &

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port
echo 1 > /sys/kernel/fast_charge/force_fast_charge

# Disable scheduler statistics to reduce overhead
write /proc/sys/kernel/sched_schedstats 0

# We are not concerned with prioritizing latency
write /dev/stune/top-app/schedtune.prefer_idle 0

# Mark top-app as boosted, find high-performing CPUs
write /dev/stune/top-app/schedtune.boost 1

# Multiplier
echo 4 > /proc/sys/kernel/sched_pelt_multiplier
