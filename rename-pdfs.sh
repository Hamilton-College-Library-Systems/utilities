#!/bin/bash

###############
# This script reads the names of subdirectories one a time
# Stores the name of the current directory.
# Looks for a PDF file in the current directory with the name PDF.pdf
# Renames that file with the core name of the current directory.
# Loops to the next directory.
###############

HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Metalogers/Robinson/L"

cd $HOME_DIR
count=0

for f in *;

   do

   # GET THE CURRENT DIRECTORY NAME

   DIRNAME=$(echo $f | cut -f1 -d".")

   echo "DIRNAME = $DIRNAME"

   PDF=$DIRNAME/PDF.pdf

   if [ -f $PDF ];
      then
         mv -f "$DIRNAME/PDF.pdf" "$DIRNAME/$DIRNAME.pdf"
         #cp "$DIRNAME/PDF.pdf" "$DIRNAME/$DIRNAME.pdf"
         count=$((count+1))
   fi
done
echo "Renamed: $count files"
