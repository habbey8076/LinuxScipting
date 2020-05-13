#!/bin/bash

# Count the number of failed login by IP address
# If there are any IPs with over LIMIT failures, display the count, IP, and location

LIMIT='10'
LOG_FILE="${1}"

# Make sure a file was supplied as an argument

if [[ ! -e "${LOG_FILE}"  ]]
then
  echo "Cannot Open the log file: ${LOG_FILE}" >&2
  exit 1
fi

# Loop through the list of failed attempts and corresponding IP addresses

grep Failed ${LOG_FILE}  | awk '{print $(NF - 3)}'  | sort | uniq -c | sort -nr | while read COUNT IP
do
  # If the number of failed is greater the limit, display count, count, IP and location

  if [[ "${COUNT}" -gt "${LIMIT}" ]]
  then
    LOCATION=$(geoiplookup ${IP} | awk -F ',' '{print $2}')
    echo "${COUNT} ${IP} ${LOCATION}"
  fi
done
exit 0
  

