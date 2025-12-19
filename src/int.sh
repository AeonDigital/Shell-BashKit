#!/usr/bin/env bash

#
# Sorts integers passed as arguments or via pipe.
#
# @param ?string $1
# Input separator character (e.g. " ", "\n", ",", ";"). Default is " ".
#
# @param ?string $2
# Output separator character (e.g. " ", "\n", ",", ";"). Default is " ".
#
# @param ?string $3
# Sort type: "asc" or "desc". Default is "asc".
#
# @param ?int $4...
# Integers to be sorted (optional if using pipe).
#
# @return int[]
intSort() {
  local inSep="${1}"
  local outSep="${2}"
  local order="${3}"
  shift 3
  local -a tmpSortArr


  # Defaults
  [[ -z "${inSep}" ]] && inSep=" "
  [[ -z "${outSep}" ]] && outSep=" "
  [[ "${order}" != "asc" && "${order}" != "desc" ]] && order="asc"


  # from stdin
  if [[ "$#" -gt "0" ]]; then
    IFS="${inSep}" read -ra tmpSortArr <<< "$*"
  else
    if [[ "${inSep}" == $'\n' ]]; then
      mapfile -t tmpSortArr
    else
      local input
      IFS= read -r input
      IFS="${inSep}" read -ra tmpSortArr <<< "$input"
    fi
  fi


  # Bubble sort
  local tmp
  for ((i=0; i<${#tmpSortArr[@]}; i++)); do
    for ((j=i+1; j<${#tmpSortArr[@]}; j++)); do
      if [[ "${order}" == "asc" && "${tmpSortArr[i]}" -gt "${tmpSortArr[j]}" ]] || [[ "${order}" == "desc" && "${tmpSortArr[i]}" -lt "${tmpSortArr[j]}" ]]; then
        tmp="${tmpSortArr[i]}"
        tmpSortArr[i]="${tmpSortArr[j]}"
        tmpSortArr[j]="${tmp}"
      fi
    done
  done


  (IFS="${outSep}"; echo "${tmpSortArr[*]}")
}