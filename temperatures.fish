#!/usr/bin/env fish

# NVMe & System Temperature Summary Script
# Usage: ./temp_summary.fish

set NORMAL (set_color normal)

# Function to format temperature
function format_temp
    awk '{printf "%.1f°C", $1/1000}'
end

# Function to get color based on temperature (in millidegrees)
function get_temp_color
    set temp_milli $argv[1]
    set temp_c (math "$temp_milli / 1000")

    if test $temp_c -lt 50
        echo (set_color brgreen)
    else if test $temp_c -lt 70
        echo (set_color bryellow)
    else
        echo (set_color brred)
    end
end

function get_fan_color
    set fan_percent $argv[1]

    if test $fan_percent -lt 60
        echo (set_color brgreen)
    else if test $fan_percent -lt 80
        echo (set_color bryellow)
    else
        echo (set_color brred)
    end
end

# System CPU Temperature
if test -f /sys/class/thermal/thermal_zone0/temp
    set sys_temp (cat /sys/class/thermal/thermal_zone0/temp)
    set color (get_temp_color $sys_temp)
    echo -e "CM5:            $color"(echo $sys_temp | format_temp)"$NORMAL"
end

# NVMe Temperatures
set nvme_hwmon /sys/block/nvme0n1/device/hwmon1

if test -d $nvme_hwmon
    for i in 2 3
        set temp_input $nvme_hwmon/temp$i"_input"
        set temp_label $nvme_hwmon/temp$i"_label"

        if test -f $temp_input; and test -f $temp_label
            set label (cat $temp_label)
            set temp (cat $temp_input)
            set temp_color (get_temp_color $temp)

            printf "NVMe %s%s%s%s\n" "$label:  " "$temp_color" (echo $temp | format_temp) "$NORMAL"
        end
    end
end

set i2c_path /sys/class/hwmon/hwmon3
set pwm (cat "$i2c_path/pwm1")
switch $pwm
    case 0
        set percent 0
    case 51
        set percent 20
    case 77
        set percent 30
    case 102
        set percent 40
    case 128
        set percent 50
    case 153
        set percent 60
    case 179
        set percent 70
    case 204
        set percent 80
    case 230
        set percent 90
    case 255
        set percent 100
end

set fan_color (get_fan_color $percent)
echo "Fan Speed:      $fan_color$percent%$NORMAL"
set rpm (cat "$i2c_path/fan1_input")
echo "Fan RPM:        $fan_color$rpm RPM$NORMAL"
