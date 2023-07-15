#!/bin/bash

# Prompt the user to enter the database name
read -p "Enter the database name: " DB_NAME

# Prompt the user to enter the OEM ID and password
read -p "Enter the OEM ID: " OEM_ID
read -s -p "Enter the OEM password: " OEM_PASSWORD
echo

# Set the blackout duration in minutes
BLACKOUT_DURATION=60

# Calculate the blackout end time
END_TIME=$(date -d "+${BLACKOUT_DURATION} minutes" +"%Y-%m-%d %H:%M:%S")

# Log in to OEM using the EMCLI
emcli login -username="${OEM_ID}" -password="${OEM_PASSWORD}"

# Create a blackout for the specified database
emcli create_blackout -name="DB_Blackout" -reason="Database blackout" -add_targets="${DB_NAME}" -duration="${END_TIME}"

# Sleep for the blackout duration
sleep "${BLACKOUT_DURATION}m"

# Remove the blackout for the specified database
emcli delete_blackout -name="DB_Blackout"

# Log out from OEM
emcli logout