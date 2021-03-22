#!/bin/bash

if [[ -z "$(command -v ffmpeg)" ]]; then
	echo "Installing ffmpeg..."
	apt update && apt install -y ffmpeg
fi
if [[ -z "$SLACK_TOKEN" ]]; then
  echo "Missing slack token..."
  exit 0
fi

rtsp_stream="${1:-rtsp://10.10.10.136:8000/stream}"
target_filename="frontdoor-$(date +'%F-%H-%M-%S').jpg"
ffmpeg -hide_banner -loglevel error -y -i $rtsp_stream -vframes 1 $target_filename

# Channel ids (csv)
target_channels="${2:-C01RUPNRN78}"

curl -s -F file=@"$target_filename" -F "initial_comment=$(date)" -F channels=$target_channels -H "Authorization: Bearer $SLACK_TOKEN" https://slack.com/api/files.upload

