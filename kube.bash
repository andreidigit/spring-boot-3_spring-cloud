#!/bin/bash

#### copy properties BASH
: ${IS_CREATE_FOLDER=false}
: ${IS_COPY_BASIC=false}
: ${IS_COPY_BASIC_HELM_SET=true}
: ${IS_COPY_BASIC_HELM_GET=false}

#### Local Variables
: ${LOCAL_ROOT_KUBE='kubernetes'}
: ${DIR_BASIC='/basic'}
: ${DIR_BASIC_HELM='/basic-helm'}

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

#### SET BASIC HELM
if [[ $IS_COPY_BASIC_HELM_SET == "true" ]]
then
pscp -r -v -i ~/"$CRED_PPK_CERTIFICATE" \
    ./$LOCAL_ROOT_KUBE$DIR_BASIC_HELM \
    "$CRED_LOGIN_ADDRESS":"$ROOT_DIR"
echo "---- 2.1. basic helm has set"
fi

#### GET BASIC HELM
if [[ $IS_COPY_BASIC_HELM_GET == "true" ]]
then
echo "---- 2.2. start to get basic helm"
pscp -r -v -i ~/"$CRED_PPK_CERTIFICATE" \
    "$CRED_LOGIN_ADDRESS":"$ROOT_DIR$DIR_BASIC_HELM" \
    ./$LOCAL_ROOT_KUBE
echo "---- 2.2. has got basic helm"
fi

#### COPY BASIC
if [[ $IS_COPY_BASIC == "true" ]]
then
pscp -r -v -i ~/"$CRED_PPK_CERTIFICATE" \
    ./$LOCAL_ROOT_KUBE$DIR_BASIC \
    "$CRED_LOGIN_ADDRESS":"$ROOT_DIR"
echo "---- 1. basic files copied"
fi

echo "end copy"
