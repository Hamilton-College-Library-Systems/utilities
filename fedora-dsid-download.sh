#!/bin/bash
#
# filename: fedora-dsid-download.sh
# Ran last from oss/home/lisham/public_html/custom-scripts
# Updated: 2015-10-08
# This script reads a list of PIDS out of a file that you have saved locally (in this case your_pids.txt).
# I used risearch to generate the list of PIDS to populate the file.
# I remove the PID namespace after generating the list and embed the namespace: in the command.
# Sample tuples risearch ...
# select $object
# from <#ri>
# where
# $object <info:fedora/fedora-system:def/relations-external#isMemberOfCollection> <info:fedora/apw:root>
#
# for the curl command replace the following
# FedoraUsername:FedoraPassword with your own creds,
# 111.111.111.111 with your repo IP,
# namespace: with your own namespace,
# MP3 with your audio file's DSID

for PID in `cat ids/ids_4_export.txt`

do
   curl --user fedoraAdmin:F3d0raT3st http://fedora.hpc.hamilton.edu:8080/fedora/objects/apw:$PID/datastreams/MODS/content > output/$PID.xml
   curl --user fedoraAdmin:F3d0raT3st http://fedora.hpc.hamilton.edu:8080/fedora/objects/apw:$PID/datastreams/OBJ/content > output/$PID.pdf
#   echo "$PID Downloaded"
done