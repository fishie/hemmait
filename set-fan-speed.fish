#!/usr/bin/env fish

set percent $argv[1]

switch $percent
    case 20
        set pwm 51
    case 30
        set pwm 77
    case 40
        set pwm 102
    case 50
        set pwm 128
    case 60
        set pwm 153
    case 70
        set pwm 179
    case 80
        set pwm 204
    case 90
        set pwm 230
    case 100
        set pwm 255
end

if not set -q pwm
    echo "Error: Invalid percentage '$percent'. Use 20, 30, 40, 50, 60, 70, 80, 90, or 100." >&2
    exit 1
end

echo "Setting PWM to $pwm ($percent%)"

# If PWM has been set to 255, the only PWM value that works is 179
set pwm_path /sys/class/hwmon/hwmon3/pwm1
echo 179 > $pwm_path
echo "$pwm" > $pwm_path

echo -n "Reading PWM to confirm it was changed..."
set new_pwm (cat $pwm_path)

if test "$new_pwm" = "$pwm"
    echo "OK"
else
    echo "fail. PWM value is $new_pwm but expected $pwm!" >&2
end
