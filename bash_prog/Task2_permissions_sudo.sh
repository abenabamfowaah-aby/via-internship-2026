#!/bin/bash

file=$1

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
       echo "Usage: ./permissions_sudo.sh <file>"
       exit 0
fi

#missing argument
if [ -z $1 ]; then
	echo "Missing argument. Provide the file name"
	echo "Usage: ./permissions_sudo.sh <file>"
	exit 1
fi

# file existence check
if [ -f "$1" ]; then
	echo "File exists."
else
	echo "Error: File does not exist."
        exit 1
fi

#current permission
echo "Current permissions:"
echo "Symbolic: $(stat -c "%A" "$1")"
echo "Numeric: $(stat -c "%a" "$1")"
echo "--------------------"
echo "Changing permissions to 644..."
chmod 644 "$1"
echo "--------------------"
echo "Adding execute permission for the owner..."
chmod u+x "$1"

#chown
if [ "$(id -u)" -eq 0 ]; then
	echo "Running as root. Attempting to change file ownership..."
	chown "$USER" "$1"

	if [ $? -eq 0 ]; then
		echo "Ownership changed successfully."
	else
		echo "Failed to change ownership."
	fi


else
	echo "Not running as root. Skipping chown because root privileges are required."
fi

echo "----------------------------------------"
echo "Permissions after changes:"
echo "Symbolic: $(stat -c "%A" "$1")"
echo "Numeric: $(stat -c "%a" "$1")"





