#!/bin/bash
# Setup Windows-style taskbar layout for x-Nord OS
# Run as the user (not root) after first login

# Reset plasma layout to default with bottom panel
kquitapp5 plasmashell 2>/dev/null || true
sleep 1

# Create default layout with bottom panel, start menu, task manager, system tray
mkdir -p ~/.config

cat > ~/.config/plasma-org.kde.plasma.desktop-appletsrc << 'EOF'
[Containments][1]
activityId=
formFactor=2
immutability=1
lastScreen=0
location=4
plugin=org.kde.panel
wallpaperPlugin=org.kde.image

[Containments][1][Applets][2]
immutability=1
plugin=org.kde.plasma.kickoff

[Containments][1][Applets][3]
immutability=1
plugin=org.kde.plasma.icontasks

[Containments][1][Applets][4]
immutability=1
plugin=org.kde.plasma.systemtray

[Containments][1][Applets][5]
immutability=1
plugin=org.kde.plasma.digitalclock

[Containments][1][General]
AppletOrder=2;3;4;5
EOF

plasmashell &
echo "x-Nord layout applied. Restart plasmashell if needed."
