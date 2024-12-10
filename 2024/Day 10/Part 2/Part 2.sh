#!/bin/bash

declare -A map
declare -A visited
rows=0
cols=0

input="/home/nuno/Advent-of-Code/2024/Day 10/input.txt"
while IFS= read -r line || [[ -n "$line" ]]; do
    map[$rows]="$line"
    cols=${#line}
    ((rows++))
done < "$input"

directions=(-1 0 1 0 0 -1 0 1)

explore_trails() {
    local row=$1
    local col=$2
    local current_height=$3

    visited["$row,$col"]=1
    local trail_count=0

    if [ "$current_height" -eq 9 ]; then
        trail_count=1
    else
        for ((i=0; i<4; i++)); do
            local new_row=$((row + ${directions[i]}))
            local new_col=$((col + ${directions[i+4]}))

            if [ $new_row -ge 0 ] && [ $new_row -lt $rows ] && [ $new_col -ge 0 ] && [ $new_col -lt $cols ]; then
                local next_height=$((${map[$new_row]:$new_col:1}))

                if [ "$next_height" -eq "$((current_height + 1))" ] && [ -z "${visited["$new_row,$new_col"]}" ]; then
                    trail_count=$((trail_count + $(explore_trails "$new_row" "$new_col" "$next_height")))
                fi
            fi
        done
    fi

    unset visited["$row,$col"]
    echo "$trail_count"
}

trails() {
    local start_row=$1
    local start_col=$2
    local start_height=$((${map[$start_row]:$start_col:1}))
    visited=()
    local rating=$(explore_trails "$start_row" "$start_col" "$start_height")
    echo "$rating"
}

total_score=0
for ((i=0; i<rows; i++)); do
    for ((j=0; j<cols; j++)); do
        if [ "${map[$i]:$j:1}" -eq 0 ]; then
            score=$(trails "$i" "$j")
            ((total_score+=score))
        fi
    done
done

echo "Total score: $total_score"