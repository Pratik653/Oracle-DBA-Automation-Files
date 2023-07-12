#!/bin/bash

# Scan Listener issue automation script

# User input for listener name and node name
read -p "Enter the listener name: " listener_name
read -p "Enter the node name: " node_name

# Check the status of the listener
listener_status=$(get_listener_status $listener_name)
echo "Listener status: $listener_status"

echo "Waiting for manual intervention --- if listener is up stop the script execution!"
sleep 30

# Timer function for manual intervention

timer() 
{
    local seconds=$timer
    while [ $seconds -ge 0 ]; do
        echo -ne "Timer: $seconds seconds \r"
        sleep 1
        ((seconds--))
    done
    echo -e "\nTimer completed!"
}

# Start the timer
timer 30

# Delete the scan listener
delete_scan_listener $listener_name $node_name


delete_scan_listener() 
{
    local listener_name=$1
    local node_name=$2
    oemctl delete scan_listener -listener_name $listener_name -node_name $node_name
}

echo "Deleted scan listener."

# Wait for 1 minutes
echo "Waiting for 1 minutes..."
sleep 60

# Add the scan listener
add_scan_listener $listener_name $node_name


add_scan_listener() 
{
    local listener_name=$1
    local node_name=$2
    oemctl add scan_listener -listener_name $listener_name -node_name $node_name
}

echo "Added scan listener."

# Wait for 2 minutes
echo "Waiting for 2 minutes..."
sleep 120

get_listener_status() 
{
    local listener_name=$1
    oemctl get listener -listener_name $listener_name
}

# Check the status of the listener
listener_status=$(get_listener_status $listener_name)
echo "Listener status: $listener_status"