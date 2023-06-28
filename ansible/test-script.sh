#!/usr/bin/env bash

SOME_PATH="/home/ubuntu/.test/credentials"

if ! [[ -d "/home/ubuntu/.test" ]]; then
    mkdir /home/ubuntu/.test
fi

if ! [[ -e "$SOME_PATH" ]]; then
  touch $SOME_PATH
  echo [default] >> $SOME_PATH
  SHELLTYPE="SHELL = "
  echo $SHELLTYPE$SHELL >> $SOME_PATH
  HOSTARCH="HOST TYPE = "
  echo $HOSTARCH$HOSTTYPE >> $SOME_PATH
fi