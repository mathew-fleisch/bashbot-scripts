#!/bin/bash

trivia_yaml=${1:-friends.yaml}

# Total number of questions
num_questions=$(yq e '.[].q' $trivia_yaml | wc -l | awk '{print $1}')

# Random question index
random_question=$(shuf -i 1-$num_questions -n 1)
random_index=$((random_question-1))

# Question
question=$(yq e '.['$random_index'].q' $trivia_yaml)

# Answer
answer=$(yq e '.['$random_index'].a' $trivia_yaml)

# Meta-Data
metadata=$(yq e '.['$random_index'].d' $trivia_yaml)

# echo "$metadata: $question"
# echo "$answer"

response=$(./slackApi.sh \
    --slack-token $SLACK_TOKEN \
    --slack-channel $TRIGGERED_CHANNEL_ID \
    --endpoint chat.postMessage \
    --message "$metadata: $question")
thread=$(echo "$response" | jq -r '.ts')
sleep 1
aresponse=$(./slackApi.sh \
    --slack-token $SLACK_TOKEN \
    --slack-channel $TRIGGERED_CHANNEL_ID \
    --endpoint chat.postMessage \
    --thread-ts $thread \
    --message "$answer")
