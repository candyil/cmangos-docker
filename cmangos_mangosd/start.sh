#!/bin/bash

# Check ENV settings and print them.
echo "==========[ CMaNGOS mangosd Init ]==========";
echo "[VAR] CHARACTERS_DB: ${CHARACTERS_DB}";
echo "[VAR] MANGOSD_DB: ${MANGOSD_DB}";
echo "[VAR] REALMD_DB: ${REALMD_DB}";
echo "";
echo "[VAR] DB_USER: ${DB_USER}";
echo "[VAR] DB_PASS: ${DB_PASS}";
echo "[VAR] REALMD_USER: ${REALMD_USER}";
echo "[VAR] REALMD_PASS: ${REALMD_PASS}";
echo "";

# Check if intialized
if [ -f "/opt/cmangos/.intialized" ]; then
    echo "[MSG] CMaNGOS already intialized. Starting mangosd...";

    # Run CMaNGOS
    #cd /opt/cmangos/bin
    #./mangosd
    exit 0;
else
    # Init Code
    echo "[MSG] CMaNGOS not intialized. Initializing...";
    touch /opt/cmangos/.intialized

    # Run CMaNGOS
    echo "[MSG] Starting mangosd...";
    #cd /opt/cmangos/bin
    #./mangosd
    exit 0;
fi