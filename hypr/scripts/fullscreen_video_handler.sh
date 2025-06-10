#!/bin/bash

# This script needs to remember the specific mpv window that went fullscreen.
# We'll store its address in this variable.
MPV_WINDOW_ADDR=""

handle() {
  local line="$1"
  local event_type=${line%%>>*}
  local event_payload=${line##*>>}

  # --- Event 1: An mpv window on the correct monitor goes fullscreen ---
  if [[ "$event_type" == "fullscreen" && "$event_payload" == "1" ]]; then
    # Check if the currently active window is mpv on the target monitor
    local active_window_info=$(hyprctl activewindow -j)
    local window_class=$(echo "$active_window_info" | jq -r '.class')
    local monitor_id=$(echo "$active_window_info" | jq -r '.monitor') # Use monitorID for numeric check

    # IMPORTANT: Change "0" to the correct Monitor ID for your DP-2.
    # Run `hyprctl monitors -j` to find the correct ID for DP-2.
    if [[ "$window_class" == "mpv" && "$monitor_id" == 0 ]]; then
      # It is! Let's remember this window's address and disable the other monitor.
      MPV_WINDOW_ADDR=$(echo "$active_window_info" | jq -r '.address' | cut -c 3-14)
      echo "mpv entered fullscreen on Monitor 0. Watching addr: $MPV_WINDOW_ADDR. Disabling DP-3."
      hyprctl keyword monitor "DP-3,disable"
    fi
  fi

  # --- Event 2: A window exits fullscreen ---
  if [[ "$event_type" == "fullscreen" && "$event_payload" == "0" ]]; then
    # Was it our tracked mpv window that just exited fullscreen?
    # We check if MPV_WINDOW_ADDR is not empty.
    if [[ -n "$MPV_WINDOW_ADDR" ]]; then
      local active_addr=$(hyprctl activewindow -j | jq -r '.address' | cut -c 3-14)
      if [[ "$active_addr" == "$MPV_WINDOW_ADDR" ]]; then
        echo "Tracked mpv window exited fullscreen. Enabling DP-3."
        hyprctl keyword monitor "DP-3,1920x1080@144,0x0,1"
        # Forget the window address, our job is done.
        MPV_WINDOW_ADDR=""
      fi
    fi
  fi

  # --- Event 3: A window closes ---
  if [[ "$event_type" == "closewindow" ]]; then
    # Was it our tracked mpv window that just closed?
    # We check if the address from the event payload matches our stored address.
    if [[ -n "$MPV_WINDOW_ADDR" && "$event_payload" == "$MPV_WINDOW_ADDR" ]]; then
      echo "Tracked mpv window was closed. Enabling DP-3."
      hyprctl keyword monitor "DP-3,1920x1080@144,0x0,1"
      # Forget the window address, our job is done.
      MPV_WINDOW_ADDR=""
    fi
  fi
}

# Use socat to listen to Hyprland's event socket
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | \
while read -r line; do
    handle "$line"
done
