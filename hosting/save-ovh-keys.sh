#!/bin/bash
# Asks for the three OVH API values (typing stays hidden) and saves them in ~/.shapesong-ovh.env, readable only by you.
umask 077
read -r -p  "Application key: " ak
read -r -s -p "Application secret: " as; echo
read -r -s -p "Consumer key: " ck; echo
printf 'export OVH_AK=%q\nexport OVH_AS=%q\nexport OVH_CK=%q\n' "$ak" "$as" "$ck" > ~/.shapesong-ovh.env
chmod 600 ~/.shapesong-ovh.env
echo "Saved in ~/.shapesong-ovh.env"
