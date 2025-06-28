#!/bin/bash

set -e

ascii_art='
  ██████╗  ███╗   ███╗  █████╗  ██╗  ██╗  ██████╗   ██████╗ 
 ██╔═══██╗ ████╗ ████║ ██╔══██╗ ██║ ██╔╝ ██╔═══██╗ ██╔════╝ 
 ██║   ██║ ██╔████╔██║ ███████║ █████╔╝  ██║   ██║ ╚█████╗  
 ██║   ██║ ██║╚██╔╝██║ ██╔══██║ ██╔═██╗  ██║   ██║  ╚═══██╗ 
 ╚██████╔╝ ██║ ╚═╝ ██║ ██║  ██║ ██║  ██╗ ╚██████╔╝ ██████╔╝ 
  ╚═════╝  ╚═╝     ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝  ╚═════╝  ╚═════╝  
'

# Define the color gradient (shades of yellow)
colors=(
  '\033[38;5;226m' # Bright Yellow
  '\033[38;5;227m' # Light Yellow
  '\033[38;5;228m' # Pale Yellow
  '\033[38;5;229m' # Cream Yellow
  '\033[38;5;230m' # Off White Yellow
  '\033[38;5;222m' # Peach Yellow
  '\033[38;5;221m' # Golden Yellow
)

# Print each line with color
i=0
echo "$ascii_art" | while IFS= read -r line; do
  color_index=$((i % ${#colors[@]}))
  echo -e "${colors[color_index]}${line}\033[0m"
  i=$((i + 1))
done