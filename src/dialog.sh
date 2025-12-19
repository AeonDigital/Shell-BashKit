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