#!/bin/bash

#### Server Variables
: ${ORIGIN_DIR='../../../../../config-repo'}
: ${DESTINATION_DIR='./components'}

# Each service needs two symbol links
# to the common configuration file: application.yaml,
# and to the microservice-specific configuration file:
# ln -s ../../../../../config-repo/application.yml application.yml
# ln -s ../../../../../config-repo/"some-service-name".yml "some-service-name".yml

# List of Service names
services=(
    "auth-server"
    "product"
    "product-composite"
    "recommendation"
    "review"
)

# Loop of Symbol link
for name in "${services[@]}"
do
  app_file="application.yml"
  service_file="$name.yml"
  ln -s "$ORIGIN_DIR/$app_file" "$DESTINATION_DIR/$name/config-repo/$app_file"
  ln -s "$ORIGIN_DIR/$service_file" "$DESTINATION_DIR/$name/config-repo/$service_file"
  echo "Symbol link $name"
done
