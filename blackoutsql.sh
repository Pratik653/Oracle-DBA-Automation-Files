#!/bin/bash

# Prompt the user to enter the database credentials
read -p "Enter the database username: " DB_USERNAME
read -s -p "Enter the database password: " DB_PASSWORD
echo

# Prompt the user to enter the database name
read -p "Enter the database name: " DB_NAME

# Set the blackout duration in minutes
BLACKOUT_DURATION=60

# Connect to the database using SQL*Plus
sqlplus -S "${DB_USERNAME}/${DB_PASSWORD}@${DB_NAME}" <<EOF

-- Create a blackout for the specified database
BEGIN
  DBMS_SCHEDULER.create_blackout(
    blackout_name    => 'DB_Blackout',
    comments         => 'Database blackout',
    blackout_type    => DBMS_SCHEDULER.isolate_database,
    start_time       => SYSTIMESTAMP,
    end_time         => SYSTIMESTAMP + INTERVAL '${BLACKOUT_DURATION}' MINUTE,
    enabled          => TRUE);
END;
/

-- Sleep for the blackout duration
BEGIN
  DBMS_LOCK.sleep('${BLACKOUT_DURATION}');
END;
/

-- Remove the blackout for the specified database
BEGIN
  DBMS_SCHEDULER.drop_blackout('DB_Blackout');
END;
/

-- Exit SQL*Plus
EXIT;
EOF