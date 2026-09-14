#!/bin/bash

# Exit codes:
# 0 = all checks passed
# 1 = missing required argument
# 2 = host unreachable
# 3 = insufficient disk space
# 4 = required file not found
# 5 = required command not found



TEMP_FILE=$(mktemp)

cleanup() {
    rm -f "$TEMP_FILE"
}

trap cleanup EXIT INT




if [ $# -ne 1 ]; then
	echo "Usage: ./return_codes_error_handling.sh <hostname>"
	exit 1
fi

check_status() {
    status=$1
    message=$2
    exit_code=$3

    if [ "$status" -eq 0 ]; then
        echo "PASS: $message"
    else
        echo "FAIL: $message"
        exit "$exit_code"
    fi
}

ping -c 1 -W 2 "$1"
check_status "$?" "Host $1 is reachable" 2

disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$disk_usage" -ge 90 ]; then
    check_status 1 "Disk usage is too high" 3
else
    check_status 0 "Disk usage is sufficient"
fi

if [ -f /etc/hosts ] && [ -r /etc/hosts ]; then
    check_status 0 "/etc/hosts exists and is readable"
else
    check_status 1 "/etc/hosts is missing or not readable" 4
fi

#command installed ?
if command -v curl > /dev/null 2>&1; then
    check_status 0 "curl is installed"
else
    check_status 1 "curl is not installed" 5
fi
