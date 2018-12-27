#!/vendor/bin/sh

# Set thermal config. These values are read by thermal-engine.
# ============== values ==============
# game -> 9
# incall -> 8
# evaluation -> 10
# class0 -> 11
# camera -> 12
# pubg -> 13
# youtube -> 14
# extreme -> 2
# arvr -> 15
# game2 -> 16
# restore -> 0 
#=====================================

echo 10 > /sys/class/thermal/thermal_message/sconfig


