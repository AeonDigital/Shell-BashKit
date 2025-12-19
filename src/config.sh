#!/usr/bin/env bash

#
# Mantain the last registered result status.
unset BASHKIT_CORE_RETURNSTATUS
declare -g BASHKIT_CORE_RETURNSTATUS=""

#
# Accept boolean values.
unset BASHKIT_CORE_BOOL
declare -gA BASHKIT_CORE_BOOL=(
  ["0"]="n no not cancel"
  ["1"]="y yes ok confirm"
)



#
# Associative array that correlates dialog message types with their 
# prefixes for presentation.
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


#
# Associative array that correlates dialog message types with their
# color code.
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


#
# Identation used for each line message after the first.
# Corresponds to the size occupied by the displayed prefix
declare -g BASHKIT_CORE_DIALOG_INDENT="        "
#
# prompt marker to be used in cases of 'question' or 'input' 
# type messages
declare -g BASHKIT_CORE_DIALOG_PROMPT_PREFIX="      > "
#
# Color None
declare -g BASHKIT_CORE_DIALOG_COLOR_NONE="\e[0m"
#
# Default text color
declare -g BASHKIT_CORE_DIALOG_COLOR_TEXT="\e[0;49m"
#
# Hightlight color (added whenever a substring is found between **)
declare -g BASHKIT_CORE_DIALOG_COLOR_HIGHLIGHT="\e[1;49m"


#
# Stores the information entered by the user when asked by a prompt.
# The information is stored until a new prompt is launched.
# Values considered invalid are not retained.
unset BASHKIT_CORE_DIALOG_PROMPT_INPUT
declare -g BASHKIT_CORE_DIALOG_PROMPT_INPUT=""

#
# Stores the raw information entered by the user when asked by a prompt.
# Keeps invalid value until a new prompt is launched.
unset BASHKIT_CORE_DIALOG_PROMPT_RAW_INPUT
declare -g BASHKIT_CORE_DIALOG_PROMPT_RAW_INPUT=""