#!/usr/bin/env bash

#
# Store the result status for lazy comparison.
#
# @param int $1
# Status code to store.
#
# @return void
statusSet() {
  BASHKIT_CORE_RETURNSTATUS="${1}"
}

#
# Get the last stored status code.
#
# @return int
statusGet() {
  echo -ne "${BASHKIT_CORE_RETURNSTATUS}"
}