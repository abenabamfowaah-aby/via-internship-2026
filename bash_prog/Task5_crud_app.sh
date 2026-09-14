#!/bin/bash

# Task 5 - CRUD Phonebook
# Exit codes:
#   0 = successful exit
#   1 = invalid usage or input
#   2 = data file error

DATA_FILE="$(dirname "$0")/phonebook.txt"

# Create the data file if it does not exist
if [ ! -f "$DATA_FILE" ]; then
    touch "$DATA_FILE"
fi

show_help() {
    echo "Phonebook CRUD Application"
    echo
    echo "Usage: ./Task5_crud_app.sh"
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo
}

add_record() {
    echo
    echo "--- Add Contact ---"

    read -p "Enter name: " name

    if [ -z "$name" ]; then
        echo "Error: Name cannot be empty."
        return 1
    fi

    read -p "Enter phone number: " phone

    if [ -z "$phone" ]; then
        echo "Error: Phone number cannot be empty."
        return 1
    fi

    read -p "Enter email: " email

    if [ -z "$email" ]; then
        echo "Error: Email cannot be empty."
        return 1
    fi

    if [ -s "$DATA_FILE" ]; then
        id=$(tail -n 1 "$DATA_FILE" | cut -d',' -f1)
        id=$((id + 1))
    else
        id=1
    fi

    echo "$id,$name,$phone,$email" >> "$DATA_FILE"

    echo "Contact added successfully."
}

view_records() {
    echo
    echo "--- Phonebook ---"

    if [ ! -s "$DATA_FILE" ]; then
        echo "Phonebook is empty."
        return 0
    fi

    printf "%-5s %-20s %-15s %-30s\n" "ID" "NAME" "PHONE" "EMAIL"
    echo "--------------------------------------------------------------------------"

    while IFS=',' read -r id name phone email
    do
        printf "%-5s %-20s %-15s %-30s\n" "$id" "$name" "$phone" "$email"
    done < "$DATA_FILE"
}

search_record() {
    echo
    echo "--- Search Contact ---"

    read -p "Enter name to search: " search_name

    if [ -z "$search_name" ]; then
        echo "Error: Search name cannot be empty."
        return 1
    fi

    result=$(grep -i ",$search_name," "$DATA_FILE")

    if [ -z "$result" ]; then
        echo "No contact found with that name."
        return 1
    fi

    echo "Contact found:"
    echo "$result"
}

update_record() {
    echo
    echo "--- Update Contact ---"

    read -p "Enter ID of contact to update: " update_id

    if [ -z "$update_id" ]; then
        echo "Error: ID cannot be empty."
        return 1
    fi

    if ! grep -q "^$update_id," "$DATA_FILE"; then
        echo "No contact found with ID $update_id."
        return 1
    fi

    echo "Contact found."

    read -p "Enter new name: " new_name
    if [ -z "$new_name" ]; then
        echo "Error: Name cannot be empty."
        return 1
    fi

    read -p "Enter new phone number: " new_phone
    if [ -z "$new_phone" ]; then
        echo "Error: Phone number cannot be empty."
        return 1
    fi

    read -p "Enter new email: " new_email
    if [ -z "$new_email" ]; then
        echo "Error: Email cannot be empty."
        return 1
    fi

    cp "$DATA_FILE" "$DATA_FILE.bak"

    sed -i "s/^$update_id,.*/$update_id,$new_name,$new_phone,$new_email/" "$DATA_FILE"

    echo "Contact updated successfully."
}

delete_record() {
    echo
    echo "--- Delete Contact ---"

    read -p "Enter ID of contact to delete: " delete_id

    if [ -z "$delete_id" ]; then
        echo "Error: ID cannot be empty."
        return 1
    fi

    if ! grep -q "^$delete_id," "$DATA_FILE"; then
        echo "No contact found with ID $delete_id."
        return 1
    fi

    echo "Contact found:"
    grep "^$delete_id," "$DATA_FILE"

    read -p "Are you sure you want to delete this contact? (y/n): " confirmation

    if [ "$confirmation" != "y" ] && [ "$confirmation" != "Y" ]; then
        echo "Delete cancelled."
        return 0
    fi

    cp "$DATA_FILE" "$DATA_FILE.bak"

    sed -i "/^$delete_id,/d" "$DATA_FILE"

    echo "Contact deleted successfully."
}

# Handle help option
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Reject unexpected arguments
if [ $# -ne 0 ]; then
    echo "Error: This script does not accept arguments."
    show_help
    exit 1
fi

# Main menu
while true
do
    echo
    echo "=============================="
    echo "       PHONEBOOK APP"
    echo "=============================="
    echo "1. Add Contact"
    echo "2. View/List Contacts"
    echo "3. Search Contact"
    echo "4. Update Contact"
    echo "5. Delete Contact"
    echo "6. Exit"
    echo "=============================="

    read -p "Choose an option: " choice

    case "$choice" in
        1)
            add_record
            ;;
        2)
            view_records
            ;;
        3)
            search_record
            ;;
        4)
            update_record
            ;;
        5)
            delete_record
            ;;
        6)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose 1-6."
            ;;
    esac
done
