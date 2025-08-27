#!/bin/sh
#  ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗
#  ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
#  ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
#  ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
#  ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
#   ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
#
#  ██╗      █████╗ ██╗   ██╗███╗   ██╗ ██████╗██╗  ██╗███████╗██████╗
#  ██║     ██╔══██╗██║   ██║████╗  ██║██╔════╝██║  ██║██╔════╝██╔══██╗
#  ██║     ███████║██║   ██║██╔██╗ ██║██║     ███████║█████╗  ██████╔╝
#  ██║     ██╔══██║██║   ██║██║╚██╗██║██║     ██╔══██║██╔══╝  ██╔══██╗
#  ███████╗██║  ██║╚██████╔╝██║ ╚████║╚██████╗██║  ██║███████╗██║  ██║
#  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#	originally written by: gh0stzk - https://github.com/gh0stzk/dotfiles
#	rewritten for hyprland by :	 develcooking - https://github.com/develcooking/hyprland-dotfiles
#	Info    - This script runs the rofi launcher, to select
#             the wallpapers included in the theme you are in.



# Set some variables
wall_dir="${HOME}/.cache/wallengine"
rofi_command="rofi -x11 -dmenu -theme ${HOME}/.config/rofi/wallSelect.rasi -theme-str ${rofi_override}"
workshop="${HOME}/.local/share/Steam/steamapps/workshop/content/431960"

# Create cache dir if not exists
if [ ! -d "${wall_dir}" ] ; then
        mkdir -p "${wall_dir}"
fi

# Create cache
find "$workshop" -name "*.mp4" | while read -r fichier
do
  path=$(echo "$fichier" | awk -F/ 'BEGIN{OFS="/"} {$NF=""; sub(OFS"$",""); print}')
  name=$(echo "$path" | awk -F/ '{print $ NF}')
  if [[ ! -f ${HOME}/.cache/wallengine/$name ]]
  then
    cp $path/preview.* ${HOME}/.cache/wallengine/$name
  fi
done


# Select a picture with rofi
wall_selection=$(find "${wall_dir}"  -maxdepth 1  -type f -exec basename {} \; | sort | while read -r A ; do  echo -en "$A\x00icon\x1f""${wall_dir}"/"$A\n" ; done | $rofi_command)


# Set the wallpaper
[[ -n "$wall_selection" ]] || exit 1
wall=$(ls ${workshop}/${wall_selection}/*.mp4 | head -1)

if pgrep -x "xwinwrap"
then
	echo oui
	pkill -9 "xwinwrap"
fi

xwinwrap -fs -ni -b -nf -ov -- mpv -wid WID --loop-file=inf --no-audio --really-quiet --vo=gpu --hwdec=vaapi --gpu-api=opengl --gpu-context=x11egl --scale=bilinear --cscale=bilinear --dscale=bilinear --opengl-swapinterval=2 --framedrop=vo --geometry=50%:50% --autofit=1920x1080 --vf=fps=20 "$wall" &

echo "$wall" > ${HOME}/.cache/.lastwal.txt

# pywal and matugen update
wal -n -i $wall_dir/$wall_selection 1>/dev/null && xdotool key Super+F5 && pywalfox update & 

exit 0
