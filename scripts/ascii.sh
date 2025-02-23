#!/bin/bash

ascii_art='
________                  __                
\_____  \   _____ _____  |  | ______  ______
 /   |   \ /     \\__  \ |  |/ /  _ \/  ___/
/    |    \  Y Y  \/ __ \|    <  <_> )___ \ 
\_______  /__|_|  (____  /__|_ \____/____  >
        \/      \/     \/     \/         \/ 
'

# Define the color gradient (shades of cyan and blue)
colors=(
  '\033[38;5;81m' # Cyan
  '\033[38;5;75m' # Light Blue
  '\033[38;5;69m' # Sky Blue
  '\033[38;5;63m' # Dodger Blue
  '\033[38;5;57m' # Deep Sky Blue
  '\033[38;5;51m' # Cornflower Blue
  '\033[38;5;45m' # Royal Blue
)

# Print each line with color
i=0
echo "$ascii_art" | while IFS= read -r line; do
  color_index=$((i % ${#colors[@]}))
  echo -e "${colors[color_index]}${line}\033[0m"
  i=$((i + 1))
done
