#!/usr/bin/env bash

SOME_PATH="/home/ubuntu/.test/credentials"

if ! [[ -d "/home/ubuntu/.test" ]]; then
    mkdir /home/ubuntu/.test
fi

if ! [[ -e "$SOME_PATH" ]]; then
  touch $SOME_PATH
  echo [default] >> $SOME_PATH
  ID="aws_access_key_id = "
  echo $ID$AWS_ACCESS_KEY_ID >> $SOME_PATH
  SECRET="aws_secret_access_key = "
  echo $SECRET$AWS_SECRET_ACCESS_KEY >> $SOME_PATH
fi