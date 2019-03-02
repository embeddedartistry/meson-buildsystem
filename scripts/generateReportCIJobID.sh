#!/bin/bash

# First argument: Name of the build

curl -s https://report.ci/queue.py | python - --token=$REPORT_CI_TOKEN --name "$1" | grep -E '{"id"\s*:\s*([0-9]+)}' > job.json
jq '.id' < job.json
