#!/bin/sh

x11vnc -ncache_cr -display :1 -forever -shared -logappend /var/log/x11vnc.log -bg -noipv6 -passwd "$VNC_SERVER_PASSWORD"

mkdir -p /root/.config/rustdesk

# Start RustDesk with custom server configuration and password
#doesn't work?
rustdesk \
  --rendezvous-server $RUSTDESK_SERVER \
  --relay-server $RUSTDESK_SERVER \
  --key $RUSTDESK_KEY \
  --password "$VNC_SERVER_PASSWORD" 
  --option allow-linux-headless Y &

  #Config Persistence: The ID and other settings are stored in /root/.config/rustdesk/RustDesk.toml
  #If the container restarts without a persistent volume, the ID may regenerate
