#!/bin/bash


set -eo pipefail

export PATH=$PATH:/usr/local/bin

main(){
  # Set arguments
  set_cmd_args "$@"

  # Run checks
  is_lab_valid

  # Execute commands/actions
  execute_command
}

usage() {
  cat - >&2 <<EOF
NAME
    $SCRIPT_NAME - Utility to setup and get the labs up and running
SYNOPSIS
    $SCRIPT_NAME [-h|--help]
    $SCRIPT_NAME [-l|--lab[=<arg>]]
                      [--]
OPTIONS
  -h, --help
          Prints hints and usage information
  -l, --lab
          Setup an specific lab
          Receives the stack as an argument. E.g: nodejs
* NOTES
---------------------------------------------------------
More commands will be added later
(WIP)
---------------------------------------------------------
EOF
}

panic() {
  for i; do
    echo -e "${i}" >&2
  done
  exit 1
}

print_error(){
  local error_message
  local error_type
  error_message="${1}"
  error_type="${2}"

  echo
  echo "********************************************************"
  echo "[ERROR] |$error_type > $error_message"
  echo "********************************************************"
  echo

  exit 1
}

print_info(){
  local info_message
  info_message="${1}"

  echo
  echo "--------------------------------------------------------"
  echo "[INFO] | $info_message"
  echo "--------------------------------------------------------"
  echo
}

is_lab_valid(){
  if [[ ! -d "$LAB" ]];
    then
      print_error "INVALID_LAB" "Cannot find lab $LAB in path $(pwd)"
    else
      print_info "Set lab in $LAB"
  fi
}

execute_command(){

	while true ; do
			case "$ACTION" in
					install)
							# TODO: Do the install action
							exit "$?"
							shift
					;;
					reset)
							# TODO: Do the reset action
							exit "$?"
							shift
					;;

					*)
							break
					;;
			esac
	done;
}

# Set the necessary command arguments
set_cmd_args() {
  for arg in "$@"; do
    echo "argument received --> [$arg]"
    echo
  done

  for i in "$@"; do
    case $i in
    -h)
      usage
      exit 0
      ;;
    -l=* | --lab=*)
      $LAB="${i#*=}"
      shift
      ;;
    -a=* | --action=*)
      $ACTION="${i#*=}"
      shift
      ;;
    *)
      ;;
    *) panic "Unknown option: '-${i}'" "See '${0} --help' for usage" ;;
    esac
  done
}

declare WORKING_DIR

declare LAB
declare ACTION
declare SCRIPT_NAME="run.sh"

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
