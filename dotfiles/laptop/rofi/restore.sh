#!/bin/bash

wall=$(cat $HOME/.cache/.lastwal.txt)

nixGLIntel xwinwrap -fs -ni -b -nf -ov -- mpv -wid WID --loop-file=inf --no-audio --really-quiet --vo=gpu --hwdec=vaapi --gpu-api=opengl --gpu-context=x11egl --scale=bilinear --cscale=bilinear --dscale=bilinear --opengl-swapinterval=2 --framedrop=vo --geometry=50%:50% --autofit=1920x1080 --vf=fps=20 "$wall" &

# commande awk qui se débarrase du nom du dernier field
preview=$(echo "$wall" | awk -F/ 'BEGIN{OFS="/"} {$NF=""; sub(OFS"$",""); print}')
preview=$(echo "$preview/preview.*")

# pywal and matugen update
wal -n -i $preview 1>/dev/null && pywalfox update &
