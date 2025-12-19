#!/usr/bin/env bash

#
# Returns the path of the directory where the script is running from the 
# indicated '${BASH_SOURCE[0]}'.
#
# @param string $1
# Current value of '${BASH_SOURCE[0]}'.
#
# @return string
script_retrievePathFromBashSource() {
  local strPath="$(tmpPath=$(dirname "${1}"); realpath "${tmpPath}")"
  if [ -d "${strPath}" ]; then
    echo "${strPath}"
  fi
}



#
# Completely clears the array 'BASHKIT_UNSET_ON_END'.
#
# @return void
script_objectRegister_Clear() {
  unset BASHKIT_UNSET_ON_END
  declare -ga BASHKIT_UNSET_ON_END=()
}

#
# Adds a new object to the list of those that must be 
# removed when the script finishes.
#
# @param string $1
# Name of the object to be removed.
#
# @return void
script_objectRegister_Append() {
  if [ "${1}" != "" ]; then
    BASHKIT_UNSET_ON_END+=("${1}")
  fi
}

#
# Unset all registered variables and functions.
#
# @return void
script_objectRegister_Unset() {
  local it=""
  for it in "${BASHKIT_UNSET_ON_END[@]}"; do
    unset "${it}"
  done

  script_objectRegister_Clear
}



#
# Load all scripts in the given array.
# Only accepts scripts with the .sh extension as valid.
#
# @param array $1
# Name of the array with the location of scripts to be loaded
#
# @param bool $2
# Check if is empty (default '0').
# 
# @return status+string
script_loadFromArray() {
  local arrayName="${1}"
  local boolCheckEmpty="${2}"
  [[ "${boolCheckEmpty}" != "1" && "${boolCheckEmpty}" != "0" ]] && boolCheckEmpty="0"
  
  if ! varIsArray "${arrayName}"; then
    messageError "The given array not exists; Array : '${arrayName}'"
    return "1"
  fi
  
  if [ "${boolCheckEmpty}" == "1" ]; then
    if varIsArrayEmpty "${arrayName}"; then
      messageError "Thn given array is empty; Array : '${arrayName}'"
      return "1"
    fi
  fi


  local -n arrayObject="${arrayName}"
  local scriptPath=""  
  for scriptPath in "${arrayObject[@]}"; do
    if [ ! -f "${scriptPath}" ] || [ "${scriptPath: -3}" != ".sh" ]; then
      messageError "Script not found or not a '.sh' file; Path : '${scriptPath}'"
      return "1"
    fi
  done


  for scriptPath in "${arrayObject[@]}"; do
    . "${scriptPath}"
  done
  
  return "0"
}



#
# Execute the target function from target script.
#
# @param fileExistentPath $1
# Path to target script.
#
# @param function $2
# Name of the target function.
#
# @param string $3...
# Parameters to be used in the target function.
#
# @return mixed
# Terminate Status of the target function will be stored with 
# 'statusSet' and can be evaluated using 'statusGet'.
script_execute() {
  local tgtFile="${1}"
  local tgtFunctionName="${2}"
  shift
  shift

  if [ ! -f "${tgtFile}" ]; then
    messageError "Script file '${tgtFile}' does not exist."
    return "1"
  fi

  . "${tgtFile}"
  $tgtFunctionName "$@"; statusSet "$?"
  unset "${tgtFunctionName}"
}