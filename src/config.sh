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



#
# Default configuration for dialog titles
unset BASHKIT_CORE_DIALOG_TITLE
declare -gA BASHKIT_CORE_DIALOG_TITLE
#
# Stores the character that should be used as the 'bullet' for the headings.
BASHKIT_CORE_DIALOG_TITLE["bullet"]="#"
#
# Code color of title bullet
BASHKIT_CORE_DIALOG_TITLE["bullet_color"]="\e[1;34m"
#
# Code color of title
BASHKIT_CORE_DIALOG_TITLE["title_color"]="\e[1;37m"
#
# Code color of subtitle
BASHKIT_CORE_DIALOG_TITLE["subtitle_color"]="\e[0;90m"
#
# Identation for each line of subtitle
BASHKIT_CORE_DIALOG_TITLE["subtitle_indent"]="  "
#
# Content to be show before title.
BASHKIT_CORE_DIALOG_TITLE["insert_before"]="\n"
#
# Content to be show after title.
BASHKIT_CORE_DIALOG_TITLE["insert_after"]="\n"



#
# Default configuration for list
unset BASHKIT_CORE_DIALOG_LIST
declare -gA BASHKIT_CORE_DIALOG_LIST
#
# Identation used for each item (inserted before bullet).
BASHKIT_CORE_DIALOG_LIST["indent"]="  "
#
# Stores the character that should be used as the 'bullet' for each list item.
BASHKIT_CORE_DIALOG_LIST["bullet"]="-"
#
# Code color for bullet
BASHKIT_CORE_DIALOG_LIST["bullet_color"]="\e[0;90m"
#
# Code color for item text
BASHKIT_CORE_DIALOG_LIST["item_color"]="\e[0;49m"
#
# Separator to be used between the itens.
BASHKIT_CORE_DIALOG_LIST["item_separator"]="\n"
#
# Content to be show before list
BASHKIT_CORE_DIALOG_LIST["insert_before"]="\n"
#
# Content to be show before list
BASHKIT_CORE_DIALOG_LIST["insert_after"]="\n\n"



#
# Default configuration for separator
unset BASHKIT_CORE_DIALOG_SEPARATOR
declare -gA BASHKIT_CORE_DIALOG_SEPARATOR
#
# character/s used to create the separator
BASHKIT_CORE_DIALOG_SEPARATOR["char"]="-"
#
# Code color of separator
BASHKIT_CORE_DIALOG_SEPARATOR["color"]="\e[1;34m"
#
# Size of the separator. 
# It will be reduced according to the value of '$COLUMNS'.
BASHKIT_CORE_DIALOG_SEPARATOR["length"]="80"
#
# Content to be show before separator
BASHKIT_CORE_DIALOG_SEPARATOR["insert_before"]="\n"
#
# Content to be show after separator
BASHKIT_CORE_DIALOG_SEPARATOR["insert_after"]="\n"





#
# Used for scripts that want to clear the environment of temporary variables 
# and functions. It should be used to record the name of each item to be 
# later reset.
unset BASHKIT_UNSET_ON_END
declare -ga BASHKIT_UNSET_ON_END=()

#
# Array to be used by scripts or functions. 
# Managed by the context.
unset BASHKIT_TMP_ARRAY
declare -ga BASHKIT_TMP_ARRAY=()

#
# Assoc array to be used by scripts or functions. 
# Managed by the context.
unset BASHKIT_TMP_ASSOC
declare -ga BASHKIT_TMP_ASSOC=()