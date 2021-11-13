#!/bin/bash


set -eo pipefail

export PATH=$PATH:/usr/local/bin

main(){
  build
}

build(){
  if [[ ! -f "docker-compose.yaml" ]];
    then
      echo "Error, cannot find docker-compose.yaml file"
      echo

      exit 1
  fi

  # docker compose build
  docker compose build
  docker compose up -d
}


#execute_tf_plan(){
#
#  WORKING_DIR="sp-sre-dev/dt-shared"
#
#  pushd "$WORKING_DIR" >/dev/null
#
#  terraform init -backend-config=backend.hcl \
#  -input=false
#
#  terraform plan
#  terraform apply
#
#  popd >/dev/null
#}

declare WORKING_DIR

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"