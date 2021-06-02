#!/bin/bash

raw=$(curl -s https://seinfeld-quotes.herokuapp.com/random)
quote=$(echo "$raw" | jq -r '.quote')
author=$(echo "$raw" | jq -r '.author')
season=$(echo "$raw" | jq -r '.season')
episode=$(echo "$raw" | jq -r '.episode')

echo "$quote"
echo "- $author (${season}x${episode})"
