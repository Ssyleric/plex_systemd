#!/bin/bash

SERVICE_PATH="/etc/systemd/system/plexmediaserver.service"
PLEX_BIN="/usr/lib/plexmediaserver/Plex Media Server"

# Crée le fichier systemd si absent
if [ ! -f "$SERVICE_PATH" ]; then
  echo "[+] Création du service Plex systemd..."
  cat <<SERVICE > "$SERVICE_PATH"
[Unit]
Description=Plex Media Server for Linux
After=network.target

[Service]
Type=simple
User=plex
Group=plex
Environment="PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/var/lib/plexmediaserver/Library/Application Support"
ExecStart=$PLEX_BIN
Restart=on-failure
TimeoutStopSec=20

[Install]
WantedBy=multi-user.target
SERVICE

  systemctl daemon-reload
  systemctl enable plexmediaserver --now
  echo "[✓] Service Plex restauré et démarré."
else
  echo "[=] Le service Plex existe déjà. Rien à faire."
fi
