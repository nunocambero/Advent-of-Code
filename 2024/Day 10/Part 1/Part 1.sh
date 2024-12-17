#!/bin/bash

declare -A map
declare -A visited
rows=0
cols=0

input="input.txt"
while IFS= read -r line || [[ -n "$line" ]]; do
    map[$rows]="$line"
    cols=${#line}
    ((rows++))
done < "$input"

directions=(-1 0 1 0 0 -1 0 1)

trails() {
    local start_row=$1
    local start_col=$2
    local -A visited=()
    local queue=()
    local count9=0

    queue+=("$start_row,$start_col")
    visited["$start_row,$start_col"]=1

    while [ ${#queue[@]} -gt 0 ]; do
        current=${queue[0]}
        queue=("${queue[@]:1}")
        row=$(echo $current | cut -d',' -f1)
        col=$(echo $current | cut -d',' -f2)

        current_height=$((${map[$row]:$col:1}))

        if [ "$current_height" -eq 9 ]; then
            ((count9++))
        fi

        for ((i=0; i<4; i++)); do
            new_row=$((row + ${directions[i]}))
            new_col=$((col + ${directions[i+4]}))

            if [ $new_row -ge 0 ] && [ $new_row -lt $rows ] && [ $new_col -ge 0 ] && [ $new_col -lt $cols ]; then
                next_height=$((${map[$new_row]:$new_col:1}))

                if [ "$next_height" -eq "$((current_height + 1))" ] && [ -z "${visited["$new_row,$new_col"]}" ]; then
                    visited["$new_row,$new_col"]=1
                    queue+=("$new_row,$new_col")
                fi
            fi
        done
    done

    echo "$count9"
}

total_score=0
for ((i=0; i<rows; i++)); do
    for ((j=0; j<cols; j++)); do
        if [ "${map[$i]:$j:1}" -eq 0 ]; then
            score=$(trails $i $j)
            ((total_score+=score))
        fi
    done
done

echo "Total score: $total_score"
