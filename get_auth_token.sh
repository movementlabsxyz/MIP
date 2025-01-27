#!/usr/bin/env bash

# We separate this part from the main script to avoid exposing test token 
# in the main script when transfering code from test code.
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

echo "$AUTH_HEADER"
