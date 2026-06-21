#!/usr/bin/env bash
set -euo pipefail

spent="${AGENT_DAILY_SPEND:-0}"
limit="${AGENT_DAILY_LIMIT:-100}"
status="${AGENT_COST_STATUS:-known}"

number_re='^[0-9]+([.][0-9]+)?$'

if [[ ! "$spent" =~ $number_re ]]; then
  echo "decision=unavailable"
  echo "reason=AGENT_DAILY_SPEND is not numeric"
  echo "max_lanes=1"
  exit 0
fi

if [[ ! "$limit" =~ $number_re ]] || awk "BEGIN { exit !($limit <= 0) }"; then
  echo "decision=unavailable"
  echo "reason=AGENT_DAILY_LIMIT is missing or invalid"
  echo "max_lanes=1"
  exit 0
fi

if [[ "$status" == "unavailable" ]]; then
  echo "decision=unavailable"
  echo "reason=cost signal unavailable"
  echo "max_lanes=2"
  exit 0
fi

if awk "BEGIN { exit !($spent >= $limit) }"; then
  echo "decision=blocked"
  echo "reason=daily spend is at or above limit"
  echo "max_lanes=1"
elif awk "BEGIN { exit !($spent >= ($limit * 0.75)) }"; then
  echo "decision=caution"
  echo "reason=daily spend is at or above 75 percent of limit"
  echo "max_lanes=3"
else
  echo "decision=safe"
  echo "reason=daily spend is below caution threshold"
  echo "max_lanes=5"
fi

