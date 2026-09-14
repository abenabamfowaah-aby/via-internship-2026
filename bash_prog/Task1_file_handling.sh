#!/bin/bash

# -----------------------------------------------------------------
# @title        Task1_file_handling.sh
# @author       Abena Bamfowaah Adusei
# @index        4181824
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  file handling Script
# @date         14th September, 2026
# -----------------------------------------------------------------


directory="$1"

# help check
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	echo "Usage: ./file_handling.sh <target_directory>"
	echo "Options:"
	echo "-h, --help    show this help message"
	echo "Example:"
	echo " ./file_handling.sh my_folder:"
	exit 0
fi

# missing argument
if [ -z "$1" ]; then
	echo "Please provide a target directory."
	echo "Usage: ./file_handling.sh <target_directory>"
	exit 1
fi


# directory existence check
if [ -d "$directory" ]; then
	echo "Directory already exists."
else
	mkdir -p "$directory"
	echo "Directory created."
fi

if [ -f "$directory/notes.txt" ]; then
	echo "File exists."
	read -p "Do you want to delete the file? (y/n): " answer

	if [ "$answer" = "y" ]; then
		rm "$directory/notes.txt"
		echo "File deleted successfully"
	else
		echo "File was not deleted"
	fi
else
	echo "File does not exist."
fi
