#!/bin/sh

WALLPAPER_DIR="$HOME/wallpapers"

CURRENT_WALLPAPER=$(swww query 2>/dev/null | grep -oP 'image: \K[^ ]+' | head -1 || echo "")

SELECTED=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.webp" \) -printf "%f\n" | sort | tofi --config "$HOME/.config/tofi/config" --prompt-text "Wallpaper: ")

# Si un wallpaper a été sélectionné, l'appliquer
if [ -n "$SELECTED" ]; then
    swww img "$WALLPAPER_DIR/$SELECTED" --transition-type any && wal -n -i "$WALLPAPER_DIR/$SELECTED" && wtype -M Logo -k n -m Logo && pywalfox update && ~/.config/wal/hooks/tofi 
fi

