#!/bin/bash

#### copy properties BASH
: ${IS_CREATE_FOLDER=false}

#### Local Variables
: ${LOCAL_ROOT_KUBE='kubernetes'}
: ${DIR_BASIC='/basic'}

#### Server Variables
: ${ROOT_DIR='/home/ai/kubernetes'}

#### Credentials
: ${CRED_SSH_CERTIFICATE='and-nop'}
: ${CRED_LOGIN_ADDRESS='ai@192.168.0.13'}
: ${CRED_PPK_CERTIFICATE='and-nop.ppk'}


function createFolder() {
  if [[ $IS_CREATE_FOLDER == "true" ]]
  then
        ssh -v -i ~/"$CRED_SSH_CERTIFICATE" "$CRED_LOGIN_ADDRESS" << EOF
#### Directory for kubernetes

  if [ -d "$ROOT_DIR" ]; then
      echo " '$ROOT_DIR' - directory already exists" ;
      rm -rf "$ROOT_DIR";
      mkdir -p "$ROOT_DIR";
      echo " '$ROOT_DIR' - directory is Recreated";
  else
      mkdir -p "$ROOT_DIR";
      echo " '$ROOT_DIR' - directory is created";
  fi
  mkdir -p "$ROOT_DIR$DIR_START";

  echo "---- service directories have been created ------"

#===
EOF
  fi
}

createFolder

#### COPY BASIC
pscp -r -v -i ~/"$CRED_PPK_CERTIFICATE" \
    ./$LOCAL_ROOT_KUBE$DIR_BASIC \
    "$CRED_LOGIN_ADDRESS":"$ROOT_DIR"
echo "---- 1. basic files copied"
