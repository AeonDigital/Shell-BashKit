#!/usr/bin/env bash

#
# Show a message to the standard output.
#
# @param string $1
# Message type.
#
# Choose one of:
# - '' or raw : without any special meaning [ default ]
# -      info : 
# -   warning : not a issue, fail or error
# -     error : systemic failure or impossibility [ like http 5xx ]
# -      fail : originating from a user input that triggered the action [ like http 4xx ]
# -        ok : monitoring of sub-steps of a process 
# -   success : completion of a main process
# -  question : force user to make a decision (usualy true/false stop/proceed questions)
# -     input : request form user a information
#
# In case of 'question' and 'input', stores the entered value 
# in 'BASHKIT_CORE_DIALOG_PROMPT_INPUT'.
#
# @param string $2
# Message text.
#
#
# @param ?function $3
# If set, must be a function used to validate prompted values.
#
# This function will receive the value entered by the user and 
# should return the status "0" or "1".
#
# In case of an error, it will simply not set the current value 
# to 'BASHKIT_CORE_DIALOG_PROMPT_INPUT' variable; 
# error messages should be provided by the validation itself.
#
#
# @param ?function $4
# If set, must be a function used to transform prompted values.
#
# If a validator function is passed, it will only perform the 
# transformation if the validation is successful.
#
# @return string+status
# Show message/prompt.
dialogShow() {
  local msgType="${1:-raw}"
  local msgText="${2}"
  local msgFnValidate="${3}"
  local msgFnTransform="${4}"

  local msgPrefix="${BASHKIT_CORE_DIALOG_TYPE_PREFIX[${msgType}]}"
  local msgPrefixColor="${BASHKIT_CORE_DIALOG_TYPE_COLOR[${msgType}]}"

  if [[ "${msgPrefix}" == "" || "${msgPrefixColor}" == "" ]]; then
    dialogShow "fail" "unknown message type '${msgType}'!"
    return "1"
  fi
  
  if [ "${msgText}" == "" ]; then
    dialogShow "fail" "message cannot be empty!"
    return "1"
  fi

  if [ "${msgFnValidate}" != "" ]; then
    if ! declare -F "${msgFnValidate}" &>/dev/null; then
      dialogShow "fail" "function '${msgFnValidate}' not exists or is not a function!"
      return "1"
    fi

    if [ "${msgFnTransform}" != "" ]; then
      if ! declare -F "${msgFnTransform}" &>/dev/null; then
        dialogShow "fail" "function '${msgFnTransform}' not exists or is not a function!"
        return "1"
      fi
    fi
  fi



  local codeNL=$'\n'
  local tmpCount="0"


  while [[ "${msgText}" =~ "**" ]]; do
    ((tmpCount++))
    if (( tmpCount % 2 != 0 )); then
      msgText="${msgText/\*\*/${BASHKIT_CORE_DIALOG_COLOR_HIGHLIGHT}}"
    else
      msgText="${msgText/\*\*/${BASHKIT_CORE_DIALOG_COLOR_NONE}}"
    fi
  done


  msgText=$(echo -ne "${msgText}")
  msgText="${msgText//${codeNL}/${codeNL}${BASHKIT_CORE_DIALOG_INDENT}}"

  local strShowMessage=""
  strShowMessage+="[ ${msgPrefixColor}${msgPrefix}${BASHKIT_CORE_DIALOG_COLOR_NONE} ] "
  strShowMessage+="${BASHKIT_CORE_DIALOG_COLOR_TEXT}${msgText}${BASHKIT_CORE_DIALOG_COLOR_NONE}"

  case "${msgType}" in
    fail|err)
      echo -e "${strShowMessage}" >&2
      ;;
    question|input)
      BASHKIT_CORE_DIALOG_PROMPT_RAW_INPUT=""
      BASHKIT_CORE_DIALOG_PROMPT_INPUT=""

      echo -e "${strShowMessage}"
      read -r -p "${BASHKIT_CORE_DIALOG_PROMPT_PREFIX}" BASHKIT_CORE_DIALOG_PROMPT_RAW_INPUT

      BASHKIT_CORE_DIALOG_PROMPT_INPUT="${BASHKIT_CORE_DIALOG_PROMPT_RAW_INPUT}"
      if [ "${msgFnValidate}" != "" ]; then
        $msgFnValidate "${BASHKIT_CORE_DIALOG_PROMPT_INPUT}"
        if [ "$?" != "0" ]; then
          BASHKIT_CORE_DIALOG_PROMPT_INPUT=""
          return "1"
        fi
      fi

      if [ "${msgFnTransform}" != "" ]; then
        BASHKIT_CORE_DIALOG_PROMPT_INPUT=$($msgFnTransform "${BASHKIT_CORE_DIALOG_PROMPT_INPUT}")
      fi
      ;;
    *)
      echo -e "${strShowMessage}"
      ;;
  esac
}



#
# Print a raw message.
#
# @param string $1
# Message to print.
#
# @return string
messageRaw() {
  dialogShow "raw" "${1}"
}

#
# Print a 'info' message.
#
# @param string $1
# Message to print.
#
# @return string
messageInfo() {
  dialogShow "info" "${1}"
}

#
# Print a 'warning' message.
#
# @param string $1
# Message to print.
#
# @return string
messageWarning() {
  dialogShow "warning" "${1}"
}

#
# Print a 'error' message.
#
# @param string $1
# Message to print.
#
# @return string
messageError() {
  dialogShow "error" "${1}"
}

#
# Print a 'fail' message.
#
# @param string $1
# Message to print.
#
# @return string
messageFail() {
  dialogShow "fail" "${1}"
}

#
# Print a 'ok' message.
#
# @param string $1
# Message to print.
#
# @return string
messageOk() {
  dialogShow "ok" "${1}"
}

#
# Print a 'success' message.
#
# @param string $1
# Message to print.
#
# @return string
messageSuccess() {
  dialogShow "success" "${1}"
}





#
# Prompt 'question'.
#
# @param string $1
# Message to print.
#
# @param ?function $2
# If set, must be a function used to validate prompted values.
#
# @param ?function $3
# If set, must be a function used to transform prompted values.
#
# @return string+string
promptQuestion() {
  dialogShow "question" "${1}" "${2}" "${3}"
  return "$?"
}

#
# Prompt 'input'.
#
# @param string $1
# Message to print.
#
# @param ?function $2
# If set, must be a function used to validate prompted values.
#
# @param ?function $3
# If set, must be a function used to transform prompted values.
#
# @return string+string
promptInput() {
  dialogShow "input" "${1}" "${2}" "${3}"
  return "$?"
}





#
# Displays a title structured according to the defined settings.
#
# @param string $1
# Title
#
# @param ?string $2
# Subtitle
#
# @param ?assoc $3
# Assoc with title configuration (default is 'BASHKIT_CORE_DIALOG_TITLE').
#
# @param ?string $4
# Content before the title. Usually one or more blank lines.
#
# if not defined, it will use the value of the 'insert_before' key from the 
# configuration associative array specified in $1
#
# @param ?string $5
# Content after the title. Usually one or more blank lines.
#
# if not defined, it will use the value of the 'insert_after' key from the 
# configuration associative array specified in $1.
#
# @return string
showTitle() {
  local codeNL=$'\n'
  local strTitle="${1}"
  local strSubTitle=$(echo -ne "${2}")
  local strConfig="${3:-BASHKIT_CORE_DIALOG_TITLE}"

  local -n assocConfig="${strConfig}"

  local strPre="${assocConfig[insert_before]}"
  local strPos="${assocConfig[insert_after]}"

  [[ "$#" -ge "4" ]] && strPre="${4}"
  [[ "$#" -ge "5" ]] && strPos="${5}"


  local strUseTitle=""
  local strUseSubTitle=""
  if [ "${assocConfig[bullet]}" != "" ]; then
    strUseTitle+="${assocConfig[bullet_color]}${assocConfig[bullet]}${BASHKIT_CORE_DIALOG_COLOR_NONE} "
  fi
  strUseTitle+="${assocConfig[title_color]}${strTitle}${BASHKIT_CORE_DIALOG_COLOR_NONE}"

  if [ "${strSubTitle}" != "" ]; then
    strUseSubTitle+="${assocConfig[subtitle_color]}"
    strUseSubTitle+="${assocConfig[subtitle_indent]}"
    strUseSubTitle+="${strSubTitle//${codeNL}/${codeNL}${assocConfig[subtitle_indent]}}"
    strUseSubTitle+="${BASHKIT_CORE_DIALOG_COLOR_NONE}"
  fi

  echo -ne "${strPre}${strUseTitle}\n${strUseSubTitle}\n${strPos}"
}





#
# Displays a horizontal separator on the screen according to the given 
# configuration.
#
# @param ?int $1
# Size of the separator. 
# It will be reduced according to the value of '$COLUMNS'.
#
# if not defined, it will use the value of the 'length' key from the 
# configuration associative array
#
# @param ?assoc $2
# Assoc with separator configuration (default is 'BASHKIT_CORE_DIALOG_SEPARATOR').
#
# @param ?string $3
# character/s used to create the separator. 
#
# if not defined, it will use the value of the 'char' key from the 
# configuration associative array specified in $1
#
# @param ?string $4
# Content to be show before separator.
#
# if not defined, it will use the value of the 'insert_before' key from the 
# configuration associative array specified in $1
#
# @param ?string $5
# Content to be show after separator.
#
# if not defined, it will use the value of the 'insert_after' key from the 
# configuration associative array specified in $1
#
# @return string
showHSeparator() {
  local strSep=""

  local strConfig="${2:-BASHKIT_CORE_DIALOG_SEPARATOR}"
  local -n assocConfig="${strConfig}"

  local intLength="${assocConfig[length]}"
  local strChar="${assocConfig[char]}"
  local strPre="${assocConfig[insert_before]}"
  local strPos="${assocConfig[insert_after]}"

  [[ "$#" -ge "1" ]] && intLength="${1}"
  [[ "$#" -ge "3" ]] && [[ "${3}" != "" ]] && strChar="${3}"
  [[ "$#" -ge "4" ]] && strPre="${4}"
  [[ "$#" -ge "5" ]] && strPos="${5}"

  if varIsInt "${intLength}" && [[ "${intLength}" -gt "${COLUMNS}" ]]; then
    intLength="${COLUMNS}"
  fi

  
  local i="0"
  for ((i=0; i<intLength; i++)); do
    strSep+="${strChar}"
  done

  strSep="${assocConfig[color]}${strSep:0:${intLength}}${BASHKIT_CORE_DIALOG_COLOR_NONE}"

  echo -ne "${strPre}${strSep}\n${strPos}"
}





#
# Displays the collection of items in an array as a structured list.
#
# @param array $1
# Name of the array with the list data.
#
# @param ?assoc $2
# Assoc with list configuration (default is 'BASHKIT_CORE_DIALOG_LIST').
#
# @param ?string $3
# Content before the list. Usually one or more blank lines.
#
# if not defined, it will use the value of the 'insert_before' key from the 
# configuration associative array specified in $1
#
# @param ?string $4
# Content after the list. Usually one or more blank lines.
#
# if not defined, it will use the value of the 'insert_after' key from the 
# configuration associative array specified in $1.
#
# @return string
showList() {
  local codeNL=$'\n'
  local -n arrValues="${1}"

  local strConfig="${2:-BASHKIT_CORE_DIALOG_LIST}"
  local -n assocConfig="${strConfig}"

  local strIndent="${assocConfig[indent]}"
  local strBullet="${assocConfig[bullet]}"
  local codeColorBullet="${assocConfig[bullet_color]}"
  local codeColorItem="${assocConfig[item_color]}"
  local strItemSeparator="${assocConfig[item_separator]}"
  

  local strPre="${assocConfig[insert_before]}"
  local strPos="${assocConfig[insert_after]}"

  [[ "$#" -ge "3" ]] && strPre="${3}"
  [[ "$#" -ge "4" ]] && strPos="${4}"


  local intBulletLength="${#strBullet}"
  local strLineIndent="${strIndent} "
  local i="0"
  for ((i=0; i<intBulletLength; i++)); do
    strLineIndent+=" "
  done


  local it=""
  local strItemLines=""
  for it in "${arrValues[@]}"; do
    it=$(echo -ne "${it}")

    if [ "${strItemLines}" != "" ]; then
      strItemLines+="${strItemSeparator}"
    fi

    strItemLines+="${strIndent}${codeColorBullet}${strBullet}${BASHKIT_CORE_DIALOG_COLOR_NONE} "
    strItemLines+="${codeColorItem}"
    strItemLines+="${it//${codeNL}/${codeNL}${strLineIndent}}"
    strItemLines+="${BASHKIT_CORE_DIALOG_COLOR_NONE}"
  done

  echo -ne "${strPre}${strItemLines}${strPos}"
}
