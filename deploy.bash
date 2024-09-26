#!/bin/bash

#### deploy BASH
: ${IS_CREATE_FOLDER=false}
: ${IS_ONLY_CONFIG=true}

#### Local Variables
: ${LOCAL_ROOT_MICRO='microservices'}
: ${DIR_PRODUCT_COMPOSITE='/product-composite-service'}
: ${DIR_PRODUCT='/product-service'}
: ${DIR_RECOMMENDATION='/recommendation-service'}
: ${DIR_REVIEW='/review-service'}

: ${LOCAL_ROOT_CLOUD='spring-cloud'}
: ${DIR_AUTH='/authorization-server'}
: ${DIR_GATEWAY='/gateway'}

: ${PATH_BUILD='/build'}
: ${PATH_LIB='/build/libs'}

#### Server Variables
: ${ROOT_DIR='/home/ai/showcase'}

#### Credentials
: ${CRED_SSH_CERTIFICATE='and-nop'}
: ${CRED_LOGIN_ADDRESS='ai@192.168.0.13'}
: ${CRED_PPK_CERTIFICATE='and-nop.ppk'}

function createFolder() {
  if [[ $IS_CREATE_FOLDER == "true" ]]
  then
        ssh -v -i ~/"$CRED_SSH_CERTIFICATE" "$CRED_LOGIN_ADDRESS" << EOF
#### Directory for microservices

  if [ -d "$ROOT_DIR" ]; then
      echo " '$ROOT_DIR' - directory already exists" ;
      rm -rf "$ROOT_DIR";
      mkdir -p "$ROOT_DIR";
      echo " '$ROOT_DIR' - directory is Recreated";
  else
      mkdir -p "$ROOT_DIR";
      echo " '$ROOT_DIR' directory is created";
  fi
  mkdir -p "$ROOT_DIR/$LOCAL_ROOT_MICRO/$DIR_PRODUCT_COMPOSITE/$PATH_LIB";
  mkdir -p "$ROOT_DIR/$LOCAL_ROOT_MICRO/$DIR_PRODUCT/$PATH_LIB";
  mkdir -p "$ROOT_DIR/$LOCAL_ROOT_MICRO/$DIR_RECOMMENDATION/$PATH_LIB";
  mkdir -p "$ROOT_DIR/$LOCAL_ROOT_MICRO/$DIR_REVIEW/$PATH_LIB";
  mkdir -p "$ROOT_DIR/$LOCAL_ROOT_CLOUD/$DIR_AUTH/$PATH_LIB";
  mkdir -p "$ROOT_DIR/$LOCAL_ROOT_CLOUD/$DIR_GATEWAY/$PATH_LIB";

  echo "---- service directories have been created ------"

#===

EOF

  fi
}

function copyJarDockerfile() {
    local path="/$1$2"
    #### COPY JARS
    pscp -r -v -i ~/"$CRED_PPK_CERTIFICATE" \
        ".$path$PATH_LIB" \
        "$CRED_LOGIN_ADDRESS":"$ROOT_DIR$path$PATH_BUILD"

    #### COPY Dockerfile
    pscp -r -v -i ~/"$CRED_PPK_CERTIFICATE" \
        ".$path/Dockerfile"\
        "$CRED_LOGIN_ADDRESS":"$ROOT_DIR$path"
}

createFolder

#### COPY CONFIG
pscp -r -v -i ~/"$CRED_PPK_CERTIFICATE" \
    ./config-repo\
    "$CRED_LOGIN_ADDRESS":"$ROOT_DIR"

#### COPY DOCKER COMPOSE
pscp -r -v -i ~/"$CRED_PPK_CERTIFICATE" \
    ./docker-compose.yml docker-compose-kafka.yml docker-compose-partitions.yml .env\
    "$CRED_LOGIN_ADDRESS":"$ROOT_DIR"

if [[ $IS_ONLY_CONFIG == "false" ]]
then

  #### COPY JARS
  copyJarDockerfile "$LOCAL_ROOT_MICRO" "$DIR_PRODUCT_COMPOSITE"
  copyJarDockerfile "$LOCAL_ROOT_MICRO" "$DIR_PRODUCT"
  copyJarDockerfile "$LOCAL_ROOT_MICRO" "$DIR_RECOMMENDATION"
  copyJarDockerfile "$LOCAL_ROOT_MICRO" "$DIR_REVIEW"

  copyJarDockerfile "$LOCAL_ROOT_CLOUD" "$DIR_AUTH"
  copyJarDockerfile "$LOCAL_ROOT_CLOUD" "$DIR_GATEWAY"

fi

#### COPY bash test file
pscp -r -v -i ~/"$CRED_PPK_CERTIFICATE" \
    ./tests/test-all.bash\
    "$CRED_LOGIN_ADDRESS":"$ROOT_DIR"
