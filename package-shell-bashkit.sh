#!/usr/bin/env bash

#
# mounted by Shell-BashKit-Shrink in 2025-12-30 17:06:36


unset BASHKIT_CORE_RETURNSTATUS
declare -g BASHKIT_CORE_RETURNSTATUS=""
unset BASHKIT_CORE_BOOL
declare -gA BASHKIT_CORE_BOOL=(
  ["0"]="n no not cancel"
  ["1"]="y yes ok confirm"
)
unset BASHKIT_CORE_DIALOG_TYPE_PREFIX
declare -gA BASHKIT_CORE_DIALOG_TYPE_PREFIX
BASHKIT_CORE_DIALOG_TYPE_PREFIX["raw"]=" - "
BASHKIT_CORE_DIALOG_TYPE_PREFIX["info"]="inf"
BASHKIT_CORE_DIALOG_TYPE_PREFIX["warning"]="wrn"
BASHKIT_CORE_DIALOG_TYPE_PREFIX["error"]="err"
BASHKIT_CORE_DIALOG_TYPE_PREFIX["fail"]=" x "
BASHKIT_CORE_DIALOG_TYPE_PREFIX["ok"]="okk"
BASHKIT_CORE_DIALOG_TYPE_PREFIX["success"]=" v "
BASHKIT_CORE_DIALOG_TYPE_PREFIX["question"]=" ? "
BASHKIT_CORE_DIALOG_TYPE_PREFIX["input"]=" < "
unset BASHKIT_CORE_DIALOG_TYPE_COLOR
declare -gA BASHKIT_CORE_DIALOG_TYPE_COLOR
BASHKIT_CORE_DIALOG_TYPE_COLOR["raw"]=""
BASHKIT_CORE_DIALOG_TYPE_COLOR["info"]="\e[1;34m"
BASHKIT_CORE_DIALOG_TYPE_COLOR["warning"]="\e[0;93m"
BASHKIT_CORE_DIALOG_TYPE_COLOR["error"]="\e[1;31m"
BASHKIT_CORE_DIALOG_TYPE_COLOR["fail"]="\e[20;49;31m"
BASHKIT_CORE_DIALOG_TYPE_COLOR["ok"]="\e[20;49;32m"
BASHKIT_CORE_DIALOG_TYPE_COLOR["success"]="\e[20;49;32m"
BASHKIT_CORE_DIALOG_TYPE_COLOR["question"]="\e[1;35m"
BASHKIT_CORE_DIALOG_TYPE_COLOR["input"]="\e[1;36m"
declare -g BASHKIT_CORE_DIALOG_INDENT="        "
declare -g BASHKIT_CORE_DIALOG_PROMPT_PREFIX="      > "
declare -g BASHKIT_CORE_DIALOG_COLOR_NONE="\e[0m"
declare -g BASHKIT_CORE_DIALOG_COLOR_TEXT="\e[0;49m"
declare -g BASHKIT_CORE_DIALOG_COLOR_HIGHLIGHT="\e[1;49m"
unset BASHKIT_CORE_DIALOG_PROMPT_INPUT
declare -g BASHKIT_CORE_DIALOG_PROMPT_INPUT=""
unset BASHKIT_CORE_DIALOG_PROMPT_RAW_INPUT
declare -g BASHKIT_CORE_DIALOG_PROMPT_RAW_INPUT=""
unset BASHKIT_CORE_DIALOG_TITLE
declare -gA BASHKIT_CORE_DIALOG_TITLE
BASHKIT_CORE_DIALOG_TITLE["bullet"]="#"
BASHKIT_CORE_DIALOG_TITLE["bullet_color"]="\e[1;34m"
BASHKIT_CORE_DIALOG_TITLE["title_color"]="\e[1;37m"
BASHKIT_CORE_DIALOG_TITLE["subtitle_color"]="\e[0;90m"
BASHKIT_CORE_DIALOG_TITLE["subtitle_indent"]="  "
BASHKIT_CORE_DIALOG_TITLE["insert_before"]="\n"
BASHKIT_CORE_DIALOG_TITLE["insert_after"]="\n"
unset BASHKIT_CORE_DIALOG_SEPARATOR
declare -gA BASHKIT_CORE_DIALOG_SEPARATOR
BASHKIT_CORE_DIALOG_SEPARATOR["char"]="-"
BASHKIT_CORE_DIALOG_SEPARATOR["color"]="\e[1;34m"
BASHKIT_CORE_DIALOG_SEPARATOR["length"]="80"
BASHKIT_CORE_DIALOG_SEPARATOR["insert_before"]="\n"
BASHKIT_CORE_DIALOG_SEPARATOR["insert_after"]="\n"
unset BASHKIT_UNSET_ON_END
declare -ga BASHKIT_UNSET_ON_END=()
unset BASHKIT_TMP_ARRAY
declare -ga BASHKIT_TMP_ARRAY=()
unset BASHKIT_TMP_ASSOC
declare -ga BASHKIT_TMP_ASSOC=()
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
messageRaw() {
  dialogShow "raw" "${1}"
}
messageInfo() {
  dialogShow "info" "${1}"
}
messageWarning() {
  dialogShow "warning" "${1}"
}
messageError() {
  dialogShow "error" "${1}"
}
messageFail() {
  dialogShow "fail" "${1}"
}
messageOk() {
  dialogShow "ok" "${1}"
}
messageSuccess() {
  dialogShow "success" "${1}"
}
promptQuestion() {
  dialogShow "question" "${1}" "${2}" "${3}"
  return "$?"
}
promptInput() {
  dialogShow "input" "${1}" "${2}" "${3}"
  return "$?"
}
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
intSort() {
  local inSep="${1}"
  local outSep="${2}"
  local order="${3}"
  shift 3
  local -a tmpSortArr
  [[ -z "${inSep}" ]] && inSep=" "
  [[ -z "${outSep}" ]] && outSep=" "
  [[ "${order}" != "asc" && "${order}" != "desc" ]] && order="asc"
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
script_retrievePathFromBashSource() {
  local strPath="$(tmpPath=$(dirname "${1}"); realpath "${tmpPath}")"
  if [ -d "${strPath}" ]; then
    echo "${strPath}"
  fi
}
script_objectRegister_Clear() {
  unset BASHKIT_UNSET_ON_END
  declare -ga BASHKIT_UNSET_ON_END=()
}
script_objectRegister_Append() {
  if [ "${1}" != "" ]; then
    BASHKIT_UNSET_ON_END+=("${1}")
  fi
}
script_objectRegister_Unset() {
  local it=""
  for it in "${BASHKIT_UNSET_ON_END[@]}"; do
    unset "${it}"
  done
  script_objectRegister_Clear
}
script_loadFromArray() {
  local arrayName="${1}"
  if ! varIsArray "${arrayName}"; then
    messageError "The given array not exists; Array : '${arrayName}'"
    return "1"
  fi
  if varIsArrayEmpty "${arrayName}"; then
    messageError "Thn given array is empty; Array : '${arrayName}'"
    return "1"
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
script_loadPackage() {
  unset BASHKIT_TMP_ARRAY
  local -ga BASHKIT_TMP_ARRAY=()
  local strPathToMainPackageDir="${1}"
  if [ ! -d "${strPathToMainPackageDir}" ]; then
    messageError "Invalid target package directory; Dir : '${strPathToMainPackageDir}'"
    return "1"
  fi
  if [ ! -f "${strPathToMainPackageDir}/config.sh" ]; then
    messageError "Cannot found 'config.sh' file in target package directory; Dir : '${strPathToMainPackageDir}'"
    return "1"
  fi
  BASHKIT_TMP_ARRAY+=("${strPathToMainPackageDir}/config.sh")
  local strTgtScript=""
  for strTgtScript in $(find "${strPathToMainPackageDir}/src" -type f -name "*.sh" | stringSort $'\n'); do
    BASHKIT_TMP_ARRAY+=("${strTgtScript}")
  done
  script_loadFromArray "BASHKIT_TMP_ARRAY" ; statusSet "$?"
  unset BASHKIT_TMP_ARRAY
  local -ga BASHKIT_TMP_ARRAY=()
  if [ $(statusGet) != "0" ]; then
    return "1"
  fi
  return "0"
}
statusSet() {
  BASHKIT_CORE_RETURNSTATUS="${1}"
}
statusGet() {
  echo -ne "${BASHKIT_CORE_RETURNSTATUS}"
}
stringIsEmpty() {
  if [ -z "${1}" ]; then
    return "0"
  fi
  return "1"
}
stringIsNotEmpty() {
  if [ -n "${1}" ]; then
    return "0"
  fi
  return "1"
}
stringTrim() {
  local strReturn="${1}"
  strReturn="${strReturn#"${strReturn%%[![:space:]]*}"}" # trim L
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -ne "${strReturn}"
}
stringTrimRaw() {
  local strReturn="${1}"
  strReturn="${strReturn#"${strReturn%%[![:space:]]*}"}" # trim L
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -n "${strReturn}"
}
stringTrimL() {
  local strReturn="${1}"
  strReturn="${strReturn#"${strReturn%%[![:space:]]*}"}" # trim L
  echo -ne "${strReturn}"
}
stringTrimLRaw() {
  local strReturn="${1}"
  strReturn="${strReturn#"${strReturn%%[![:space:]]*}"}" # trim L
  echo -n "${strReturn}"
}
stringTrimR() {
  local strReturn="${1}"
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -ne "${strReturn}"
}
stringTrimRRaw() {
  local strReturn="${1}"
  strReturn="${strReturn%"${strReturn##*[![:space:]]}"}" # trim R
  echo -n "${strReturn}"
}
stringPadding() {
  local strReturn="${1}"
  local strChar="${2}"
  local strLength="${3}"
  local strPosition="${4,,U}"
  local strReturnRaw="${5}"
  if [ "${strChar}" == "" ]; then
    return "10"
  fi
  if ! [[ "${strLength}" =~ ^-?[0-9]+$ ]]; then
    return "11"
  fi
  if [ "${strPosition}" != "l" ] && [ "${strPosition}" != "r" ]; then
    return "12"
  fi
  if [ "${strReturnRaw}" != "0" ] && [ "${strReturnRaw}" != "1" ]; then
    strReturnRaw="0"
  fi
  local currentLength="${#strReturn}"
  while [ "${currentLength}" -lt "${strLength}" ]; do
    if [ "${strPosition}" == "l" ]; then
      strReturn="${strChar}${strReturn}"
    else
      strReturn="${strReturn}${strChar}"
    fi
    currentLength="${#strReturn}"
  done
  if [ "${strReturnRaw}" == "1" ]; then
    echo -n "${strReturn}"
  else 
    echo -ne "${strReturn}"
  fi
}
stringPaddingL() {
  stringPadding "${1}" "${2}" "${3}" "l" "0"
}
stringPaddingR() {
  stringPadding "${1}" "${2}" "${3}" "r" "0"
}
stringPaddingLRaw() {
  stringPadding "${1}" "${2}" "${3}" "l" "1"
}
stringPaddingRRaw() {
  stringPadding "${1}" "${2}" "${3}" "r" "1"
}
stringRemoveGlyphs() {
  echo -ne "${1}" | iconv --from-code="UTF8" --to-code="ASCII//TRANSLIT"
}
stringCapitalizeFirst() {
  local str="${1}"
  local sep=$(stringTrim "${2}")
  if [ "${sep}" == "" ]; then
    sep=" "
  else
    sep="${sep:0:1}"
  fi
  local strReturn=""
  local -a arrParts=()
  IFS="${sep}" read -ra arrParts <<< "${str}"
  local strPart=""
  for strPart in "${arrParts[@]}"; do
    strReturn+="${strPart^}${sep}"
  done
  strReturn="${strReturn%-}"
  echo "${strReturn}"
}
stringSort() {
  local inSep="${1}"
  local outSep="${2}"
  local order="${3}"
  shift 3
  local -a tmpSortArr=()
  [[ -z "${inSep}" ]] && inSep=" "
  [[ -z "${outSep}" ]] && outSep=" "
  [[ "${order}" != "asc" && "${order}" != "desc" ]] && order="asc"
  if [ -t 0 ]; then
    IFS="${inSep}" read -ra tmpSortArr <<< "$*"
  else
    if [[ "${inSep}" == $'\n' ]]; then
      mapfile -t tmpSortArr
    else
      local input
      IFS= read -r input
      IFS="${inSep}" read -ra tmpSortArr <<< "${input}"
    fi
  fi
  local tmp
  for ((i=0; i<${#tmpSortArr[@]}; i++)); do
    for ((j=i+1; j<${#tmpSortArr[@]}; j++)); do
      if [[ "${order}" == "asc" && "${tmpSortArr[i]}" > "${tmpSortArr[j]}" ]] || [[ "${order}" == "desc" && "${tmpSortArr[i]}" < "${tmpSortArr[j]}" ]]; then
        tmp="${tmpSortArr[i]}"
        tmpSortArr[i]="${tmpSortArr[j]}"
        tmpSortArr[j]="${tmp}"
      fi
    done
  done
  (IFS="${outSep}"; echo "${tmpSortArr[*]}")
}
varDump() {
  local varName="${1}"
  local varValue="${!varName}"
  local -A assocMetaData
  assocMetaData["type"]="string"
  assocMetaData["readonly"]="0"
  assocMetaData["exported"]="1"
  local printDump="1"
  if [ "${3}" == "0" ]; then
    printDump="0"
  fi
  local rawDeclareInfo=""
  rawDeclareInfo=$(declare -p "${varName}" 2>/dev/null)
  local declareStatus=""
  declareStatus=$(stringTrim "${rawDeclareInfo#declare -}")
  declareStatus=$(stringTrim "${declareStatus%% *}")
  if ! declare -p "${varName}" &>/dev/null; then
    assocMetaData["unset"]="1"
  else
    if [[ "${declareStatus}" =~ "r" ]]; then
      assocMetaData["readonly"]="1"
    fi
    if [[ "${declareStatus}" =~ "x" ]]; then
      assocMetaData["exported"]="1"
    fi
    if [[ "${declareStatus}" =~ "a" ]] || [[ "${declareStatus}" =~ "A" ]]; then
      if [[ "${declareStatus}" =~ "a" ]]; then
        assocMetaData["type"]="array"
      fi
      if [[ "${declareStatus}" =~ "A" ]]; then
        assocMetaData["type"]="assoc"
      fi
    else
      if [[ "${declareStatus}" =~ "i" ]]; then
        assocMetaData["type"]="integer"
      fi
    fi
  fi
  if [ "${2}" != "" ]; then
    local -n tmpRefVarDump_ExportAssoc="${2}"
    if ! varAssocClear "${2}" ]; then
      return "1"
    fi
    local it=""
    for it in "${!assocMetaData[@]}"; do
      tmpRefVarDump_ExportAssoc["${it}"]="${assocMetaData[${it}]}"
    done
  fi
  if [ "${printDump}" == "1" ]; then
    echo "# Dump variable"
    echo "## Variable '${varName}':"
    if [ "${assocMetaData["unset"]}" == "1" ]; then
      echo "   - unset"
    else
      if [ "${assocMetaData["readonly"]}" == "1" ]; then
        echo "   - readonly"
      fi
      if [ "${assocMetaData["exported"]}" == "1" ]; then
        echo "   - exported"
      fi
      echo "   - ${assocMetaData["type"]}"
      echo ""
      if [ "${assocMetaData["type"]}" == "array" ] || [ "${assocMetaData["type"]}" == "assoc" ]; then
        echo "## ${assocMetaData["type"]^} values"
        local -n tmpRefVarDump_ArrayAssocPrintValues="${varName}"
        local k=""
        local v=""
        for k in $(varAssocKeys "asc" "tmpRefVarDump_ArrayAssocPrintValues"); do
          v="${tmpRefVarDump_ArrayAssocPrintValues[${k}]}"
          echo "   [${k}]='${v}'"
        done
      else
        if [ "${assocMetaData["type"]}" == "integer" ]; then
          echo "## Value : ${varValue}"
        else
          echo "## Value : '${varValue}'"
        fi
      fi
    fi
  fi
}
varIsSet() {
  if [ -v "${1}" ]; then
      return "0"
  fi
  return "1"
}
varIsBool() {
  local boolValue="${1}"
  if [ "${boolValue}" != "0" ] && [ "${boolValue}" != "1" ]; then
    return "1"
  fi
  return "0"
}
varIsStringBool() {
  local key=""
  for key in "${!BASHKIT_CORE_BOOL[@]}"; do
    local words=""
    for word in ${BASHKIT_CORE_BOOL[$key]}; do
      if [[ "${1,,}" == "${word}" ]]; then
        return "0"
      fi
    done
  done
  return "1"
}
varStringBoolToBool() {
  local key=""
  for key in "${!BASHKIT_CORE_BOOL[@]}"; do
        local words=""
    for word in ${BASHKIT_CORE_BOOL[$key]}; do
      if [[ "${1,,}" == "${word}" ]]; then
        echo -ne "${key}"
      fi
    done
  done
}
varIsInt() {
  local intValue="${1}"
  if ! [[ "${intValue}" =~ ^-?[0-9]+$ ]]; then
    return "1"
  fi
  return "0"
}
varIsFloat() {
  local floatValue="${1}"
  if ! [[ "${floatValue}" =~ ^-?[0-9]*\.?[0-9]+$ ]]; then
    return "1"
  fi
  return "0"
}
varIsArray() {
  local arrayName="${1}"
  if [ "${arrayName}" == "" ] || [[ "$(declare -p "${arrayName}" 2> /dev/null)" != "declare -a"* ]]; then
    return "1"
  fi
  return "0"
}
varIsAssoc() {
  local assocName="${1}"
  if [ "${assocName}" == "" ] || [[ "$(declare -p "${assocName}" 2> /dev/null)" != "declare -A"* ]]; then
    return "1"
  fi
  return "0"
}
varIsArrayEmpty() {
  local -n arr="${1}"
  if [ "${#arr[@]}" -gt "0" ]; then
    return "1"
  fi
  return "0"
}
varIsArrayExistsAndIsEmpty() {
  local arrName="${1}"
  if ! varIsArray "${arrName}" && ! varIsAssoc "${arrName}"; then
    return "1"
  fi
  local -n arr="${arrName}"
  if [ "${#arr[@]}" -gt "0" ]; then
    return "1"
  fi
  return "0"
}
varArrayExistsAndHasNoItens() {
  varIsArrayExistsAndIsEmpty "${1}"; return "$?"
}
varIsArrayExistsAndIsNotEmpty() {
  local arrName="${1}"
  if ! varIsArray "${arrName}" && ! varIsAssoc "${arrName}"; then
    return "1"
  fi
  local -n arr="${arrName}"
  if [ "${#arr[@]}" -eq "0" ]; then
    return "1"
  fi
  return "0"
}
varArrayExistsAndHasItens() {
  varIsArrayExistsAndIsNotEmpty "${1}"; return "$?"
}
varArrayClear() {
  if ! varIsArray "${1}" ]; then
    messageError "return array '${1}' not exists or is not an array!"
    return "1"
  fi
  local -n tmpArrayClear="${1}"
  tmpArrayClear=()
  return "0"
}
varAssocClear() {
  if ! varIsAssoc "${1}" ]; then
    messageError "return assoc '${1}' not exists or is not an assoc array!"
    return "1"
  fi
  local -n tmpAssocClear="${1}"
  local it=""
  for it in "${!tmpAssocClear[@]}"; do
    unset tmpAssocClear["${it}"]
  done
  return "0"
}
varArrayIndex() {
  local order="${1}"
  local -n tmpArr="${2}"
  intSort " " $'\n' "${order}" "${!tmpArr[@]}"
}
varArrayValues() {
  local order="${1}"
  local -n tmpArr="${2}"
  local strTmpValues=$(tmp=""; sep=$'\t'; for it in "${tmpArr[@]}"; do tmp+="${sep}${it}"; done; echo -ne "${tmp:1}")
  stringSort $'\t' $'\n' "${order}" "${strTmpValues}"
}
varAssocKeys() {
  local order="${1}"
  local -n tmpAssoc="${2}"
  local strTmpValues=$(tmp=""; sep=$'\t'; for it in "${!tmpAssoc[@]}"; do tmp+="${sep}${it}"; done; echo -ne "${tmp:1}")
  stringSort $'\t' $'\n' "${order}" "${strTmpValues}"
}
varAssocValues() {
  local order="${1}"
  local -n tmpAssoc="${2}"
  local strTmpValues=$(tmp=""; sep=$'\t'; for it in "${tmpAssoc[@]}"; do tmp+="${sep}${it}"; done; echo -ne "${tmp:1}")
  stringSort $'\t' $'\n' "${order}" "${strTmpValues}"
}
varIsFunction() {
  local functionName="${1}"
  if [ "${functionName}" == "" ] || ! declare -F "${functionName}" &>/dev/null; then
    return "1"
  fi
  return "0"
}
varIsCommand() {
  local commandName="${1}"
  if command -v $commandName > /dev/null 2>&1; then
    return "0"
  fi
  return "1"
}
varIsSymolicLink() {
  local fullSymnbolicLink="${1}"
  if [ -L "${fullSymnbolicLink}" ]; then
    return "0"
  fi
  return "1"
}
varIsFile() {
  local fullFileName="${1}"
  if [ ! -f "${fullFileName}" ]; then
    return "1"
  fi
  return "0"
}
varIsFileEmpty() {
  local fullFileName="${1}"
  if varIsFile "${fullFileName}" && [ ! -s "${fullFileName}" ]; then 
    return "0"
  fi
  return "1"
}
varIsFileNotEmpty() {
  local fullFileName="${1}"
  if varIsFile "${fullFileName}" && [ -s "${fullFileName}" ]; then 
    return "0"
  fi
  return "1"
}
varIsDir() {
  local fullDirName="${1}"
  if [ ! -d "${fullDirName}" ]; then
    return "1"
  fi
  return "0"
}
varIsDirEmpty() {
  local fullDirName="${1}"
  if varIsDir "${fullDirName}" && [ -z "$(ls -A "${fullDirName}")" ]; then 
    return "0"
  fi
  return "1"
}
varIsDirNotEmpty() {
  local fullDirName="${1}"
  if varIsDir "${fullDirName}" && [ ! -z "$(ls -A "${fullDirName}")" ]; then 
    return "0"
  fi
  return "1"
}
varIsResourceReadable() {
  local fullResourceName="${1}"
  if [ -e "${fullResourceName}" ] && [ -r "${fullResourceName}" ]; then 
    return "0"
  fi
  return "1"
}
varIsResourceWritable() {
  local fullResourceName="${1}"
  if [ -e "${fullResourceName}" ] && [ -w "${fullResourceName}" ]; then 
    return "0"
  fi
  return "1"
}
varIsResourceExecutable() {
  local fullResourceName="${1}"
  if [ -a "${fullResourceName}" ] && [ -x "${fullResourceName}" ]; then 
    return "0"
  fi
  return "1"
}
varIsResourceOwnedByCurrentUser() {
  local fullResourceName="${1}"
  if [ -a "${fullResourceName}" ] && [ -O "${fullResourceName}" ]; then 
    return "0"
  fi
  return "1"
}
varIsResourceOwnedByCurrentGroup() {
  local fullResourceName="${1}"
  if [ -a "${fullResourceName}" ] && [ -G "${fullResourceName}" ]; then 
    return "0"
  fi
  return "1"
}