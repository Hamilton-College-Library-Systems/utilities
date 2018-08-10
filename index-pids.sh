#!/bin/bash

FH=$FEDORA_HOME
USERNAME="fedoraAdmin"
PASSWORD="F3d0raT3st"
HOST="fedora.hamilton.edu"
PORT="8080"
PROT="http"
PIDS="/home2/lisham/pids/pids.txt"


cat $PIDS | while read line; do
  curl -XPOST -u"$USERNAME:$PASSWORD" "$PROT://$HOST:$PORT/fedoragsearch/rest?operation=updateIndex&action=fromPid&value=$line"
done