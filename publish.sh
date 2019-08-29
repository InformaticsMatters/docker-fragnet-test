#!/usr/bin/env bash

# Usage: ./publish.sh <TAG>
#
# Pushes the running test container as an image to Docker hub.
#
# This script assumes you've started the conatienr image
# and have waited for your initialisation/cypher-scripts
# to complete - i.e. that neo4j has settled down to an idle state.
# It commits the running 'fragnet-test' image using the TAG provided.
#
# We simply commit and push the resultant image.
# The '.once' script will not run again in the new image.

if [ $# -ne 1 ]; then
  echo 'Usage: ./publish.sh <TAG>'
  exit 1
fi

# How many fragnet test containers do we have?
# For this to work we assume there's only one test container
CONTAINER_COUNT=$(docker ps -a | grep -c '/fragnet-test:')
if [ "$CONTAINER_COUNT" -ne 1 ]; then
  echo "Couldn't find a running 'fragnet-test' container. Is it running?"
  exit 1
fi

CONTAINER_ID=$(docker ps -a | grep fragnet-test | tr -s ' ' | cut -d' ' -f1)
CONTAINER_IMAGE=$(docker ps -a | grep fragnet-test | tr -s ' ' | cut -d' ' -f2 | cut -d: -f 1)
if [ -z "$CONTAINER_ID" ]; then
  echo "Couldn't get the 'fragnet-test' container ID. Is it running?"
  exit 1
else
  echo "Publishing container $CONTAINER_ID as $CONTAINER_IMAGE:$1..."
  docker commit "$CONTAINER_ID" "$CONTAINER_IMAGE":"$1"
  docker push "$CONTAINER_IMAGE":"$1"
  echo "Published."
fi
