#!/bin/bash

# hyprctl notify -1 1000 0 "NOTIFY"

# test if active workspace is zen workspace
WORKSPACE=$(hyprctl -j activeworkspace | jaq -r '.' )
ID=$(echo $WORKSPACE | jaq -r '.id')

if [ $(echo $WORKSPACE | jaq -r '.name') = "zen" ]; then
    # current workspace is zen workspace, so toggle zen workspace
    # simply rename the current workspace to its id
    hyprctl -r dispatch renameworkspace $ID $ID
    exit
fi

# if not, check if there are any workspaces marked as zen

ZEN_WORKSPACE=$(hyprctl -j workspaces | jaq -r '.[] | select(.name == "zen") | .name')

echo $ZEN_WORKSPACE

if [ ! -z $ZEN_WORKSPACE ]; then
    # zen workspace found
    # go to zen workspace

    hyprctl dispatch workspace name:zen
else
    # zen workspace not found
    # convert the current workspace into a zen workspace
    hyprctl -r dispatch renameworkspace $ID zen
fi
