#!/usr/bin/env bash

cd ../spring-cloud/
mkdir config-server

spring init \
--boot-version=3.2.3 \
--type=gradle-project \
--java-version=17 \
--packaging=jar \
--name=config-server \
--package-name=com.example.springcloud.configserver \
--groupId=com.example \
--dependencies=actuator,security, \
--version=1.0.0-SNAPSHOT \
config-server
