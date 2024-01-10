#!/bin/bash

# Slack API token
TOKEN="xoxp-api-token"

# User ID of the person you want to invite
USER_ID="User-id"

# CSV file path (format channel_name,channel_id)
CSV_FILE_PATH="cast_external_conection_list.csv"


# Function to invite user to a channel
invite_to_channel() {
    channel_name=$1
    channel_id=$2

    # Slack API endpoint for inviting a user to a channel
    SLACK_API_ENDPOINT="https://slack.com/api/conversations.invite"

    # Making the API request
    RESPONSE=$(curl -s -X POST -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json; charset=utf-8" \
        -d "{\"channel\":\"$channel_id\",\"users\":\"$USER_ID\"}" \
        $SLACK_API_ENDPOINT)

    # Checking if the invitation was successful
    if [[ $RESPONSE == *"\"ok\":true"* ]]; then
        echo "User successfully added to channel $channel_name ($channel_id)"
    else
        echo "Failed to add user to channel $channel_name ($channel_id)"
        echo $RESPONSE
    fi
}

# Displaying the CSV file
echo "These are the list of channels:"
while IFS=, read -r channel_name channel_id
do
    echo "$channel_name ($channel_id)"
done < "$CSV_FILE_PATH"

# Asking the user to confirm
read -p "Do you want to proceed? Press Y to continue, N to exit: " choice
if [[ $choice != [Yy] ]]; then
    echo "Exiting..."
    exit 0
fi

# Second confirmation
read -p "Repeat next sentence 3 time else it wont work - 'I will Buy Ronak a Coffee' ? Press Y if done: " ready_choice
if [[ $ready_choice != [Yy] ]]; then
    echo "Exiting..."
    exit 0
fi

# Reading the CSV file line by line and inviting user
while IFS=, read -r channel_name channel_id
do
    invite_to_channel "$channel_name" "$channel_id"
done < "$CSV_FILE_PATH"
