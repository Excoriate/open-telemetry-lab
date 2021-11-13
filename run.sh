#!/bin/bash


set -eo pipefail

export PATH=$PATH:/usr/local/bin

main(){
  # Set arguments
  set_cmd_args "$@"

  # Run checks
  run_validations

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
    $SCRIPT_NAME [-a|--action[=<arg>]]
                      [--]
OPTIONS
  -h, --help
          Prints hints and usage information
  -l, --lab
          Setup an specific lab
          Receives the stack as an argument. E.g: nodejs
  -a, --action
          An specific action to run upon a passed lab
          E.g: install/reset
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
  error_message="${2}"
  error_type="${1}"

  echo
  echo "********************************************************"
  echo "[ERROR] | $error_type > $error_message"
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

run_validations() {
  # Validate required arguments
  if [[ -z "$LAB" ]];
    then
      print_error "INVALID_ARGS" "argument lab (--lab) is required."
    else
      # check whether the lab passed is valid (as a directory)
      is_lab_valid
  fi

  if [[ -z "$ACTION" ]];
    then
      print_error "INVALID_ARGS" "argument action (--action) is required."
  fi
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
							action_install
							exit "$?"
							shift
					;;
					reset)
							action_reset
							exit "$?"
							shift
					;;

					*)
							break
					;;
			esac
	done;
}

action_install(){
 pushd "$LAB" >/dev/null

 make install # Run the make file with all the required logic

 popd >/dev/null
}

action_reset(){
 pushd "$LAB" >/dev/null

 make reset # Run the make file with all the required logic

 popd >/dev/null
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
      local raw_arg
      raw_arg="${i#*=}"
      LAB="$raw_arg"
      shift
      ;;
    -a=* | --action=*)
      local raw_arg
      raw_arg="${i#*=}"
      ACTION="$raw_arg"
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
