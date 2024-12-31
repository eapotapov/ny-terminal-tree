#!/bin/bash
trap "tput reset; tput cnorm; exit" 2
clear
tput civis

# Get terminal dimensions
term_width=$(tput cols)
term_height=$(tput lines)

# Calculate tree dimensions based on terminal size
tree_height=$((term_height * 3 / 4))
max_width=$((tree_height * 2 - 1))
if [ $max_width -gt $((term_width - 4)) ]; then
    max_width=$((term_width - 4))
    tree_height=$((max_width / 2 + 1))
fi

# Center the tree
col=$((term_width / 2))
c=$((col-1))
lin=2
color=0
tput setaf 2; tput bold

# Tree - scaled based on terminal size
for ((i=1; i<=max_width; i+=2))
{
    tput cup $lin $((col - i/2))
    for ((j=1; j<=i; j++))
    {
        echo -n \*
    }
    let lin++
    if [ $lin -ge $((tree_height + 2)) ]; then
        break
    fi
}

tput sgr0; tput setaf 3

# Trunk - scale with tree size
trunk_height=$((tree_height / 8))
if [ $trunk_height -lt 2 ]; then
    trunk_height=2
fi
trunk_width=$((tree_height / 6))
if [ $trunk_width -lt 3 ]; then
    trunk_width=3
fi
trunk_str=$(printf '%*s' $trunk_width | tr ' ' 'm')

for ((i=1; i<=trunk_height; i++))
{
    tput cup $((lin++)) $((c - trunk_width/2))
    echo $trunk_str
}

new_year=2025
tput setaf 1; tput bold
tput cup $lin $((c - 6)); echo HAPPY NEW YEAR
tput cup $((lin + 1)) $((c - 10)); echo -n "Debug Your Way Into "  # Added single space after 'Into'
let c++
k=1

# Lights and decorations - scaled to tree size
while true; do
    for ((i=1; i<=max_width; i++)) {
        # Turn off the lights
        [ $k -gt 1 ] && {
            tput setaf 2; tput bold
            tput cup ${line[$[k-1]$i]} ${column[$[k-1]$i]}; echo \*
            unset line[$[k-1]$i]; unset column[$[k-1]$i]
        }

        # Scale light positions to tree size
        li=$((RANDOM % (tree_height-2) + 3))
        width_at_height=$((2 * (li-2) + 1))
        start=$((c - width_at_height/2))
        co=$((RANDOM % width_at_height + start))
        
        tput setaf $color; tput bold
        tput cup $li $co
        echo o
        line[$k$i]=$li
        column[$k$i]=$co
        color=$(((color+1)%8))
        
        # Flashing year instead of CODE
        sh=1
        for l in 2 0 2 5
        do
            tput cup $((lin+1)) $((c+8+sh))  # Adjusted to c+8+sh to account for single space
            echo $l
            let sh++
            sleep 0.01
        done
    }
    k=$((k % 2 + 1))
done
