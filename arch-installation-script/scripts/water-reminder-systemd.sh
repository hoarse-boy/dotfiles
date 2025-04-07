#!/bin/bash

set -ex

# Just need to reload and enable the service
systemctl --user daemon-reload
systemctl --user enable --now water-reminder.timer

# Verify the timer is active
systemctl --user list-timers --all | grep water-reminder

echo "Water reminder activated successfully!"
echo
