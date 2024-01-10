#!/bin/bash

# Your Slack API Token
SLACK_TOKEN="xoxp-468487775955-49wdwdwdwdwdc4dwdwdwdwdw3b06"


# Slack API endpoint for listing channels
API_ENDPOINT="https://slack.com/api/conversations.list"

# Function to fetch channels with pagination
fetch_channels() {
    local cursor="$1"
    local params="types=public_channel,private_channel&limit=100&cursor=$cursor"

    # Make the API call and capture the response
    RESPONSE=$(curl -s -X GET -H "Authorization: Bearer $SLACK_TOKEN" -H "Content-Type: application/x-www-form-urlencoded" "$API_ENDPOINT?$params")

    # Check if the API call was successful
    if [[ $(echo "$RESPONSE" | jq -r '.ok') != "true" ]]; then
        echo "Error fetching channels: $(echo "$RESPONSE" | jq -r '.error')" >&2
        exit 1
    fi

    # Print the channel names and IDs
    echo "$RESPONSE" | jq -r '.channels[] | "\(.name), \(.id)"'

    # Extract the next cursor
    NEXT_CURSOR=$(echo "$RESPONSE" | jq -r '.response_metadata.next_cursor')

    if [[ -n "$NEXT_CURSOR" && "$NEXT_CURSOR" != "null" ]]; then
        fetch_channels "$NEXT_CURSOR"
    fi
}

# Start fetching channels
fetch_channels ""

