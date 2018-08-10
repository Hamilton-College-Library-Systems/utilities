#!/bin/bash
# #-- ~/islandora-scripts/tiffs_singles_to_zips-01.sh
# updated:  (2017-02-27)
###########################
# Description
# This script creates zip files of a directory containing matching TIFFs and MODS files. It does NOT create any derivates.
# This script can be used when you have corresponding TIFF and MODS files for single-object items such as
# PDFs, images (single-sided).
# Do not use sequence numbers in the filenames since these are single-object items: xxx_s001, xxx_s002 (examples).
# These paths for the TIFFs and MODs files are hardcoded and point to directories on diglib-15.
#-- diglib-15/techSpace/ingest-prep/input
#-- diglib-15/techSpace/ingest-prep/mods
# You need to configure the script for
#-- the size of the zip file it create.
# The script output goes to the "/output" directory: ~/islandora-scripts/output
# When the current output directory reaches the specified maximum size, the script
#-- stops copying files there
#-- zips the whole directory into the "/zips" directory.
# It then creates a new directory and starts the process over again.
# The zip file can be ingested manually into a collection using the Islandora GUI, but keep the zip filesize below 1.7 GB.
# If ingesting into a Islandora Vagrant you may need to keep the zip file size below 500 MB.
# Islandora will create all the derivatives.
# For automatic derivative creation use: tiffs_of_multiple_issues_to_one_zip-01.sh.
###########################

HOMEDIR=`pwd`
INPUTPATH=~/diglib-15/techSpace/ingest-prep/input
MODSPATH=~/diglib-15/techSpace/ingest-prep/mods
ZIPPATH=~/diglib-15/techSpace/ingest-prep/zips

# Remove all files in the output folder
if [ -d "output" ]
 then
    rm -rf output
    mkdir output
 else
    mkdir output
fi

# SET THE INITIAL OUTPUT DIRECTORY NAME
FLAG=1
DIRNAME=$(printf "%04d\n" $FLAG)
# SET THE INITIAL DIRECTORY SIZE
DIRSIZE=0

#fileCount=$( ls -l input | wc -l )
#echo "filecount01 = $fileCount"
count=0
echo "homedir - $HOMEDIR"
echo "inputpath - $INPUTPATH"

cd "$INPUTPATH"

for f in *;
do
   count=$((count+1))
   echo $count
   # GET THE CURRENT FILE NAME
# FILENAME=$(echo $f | cut -f1 -d"/")
# FILENAME=$(echo $f | cut -f1 -d"_")
   FILENAME=$(echo $f | cut -f1 -d".")
#   echo "filename = $FILENAME"
#  echo "f = $f"

   # GET THE CURRENT FILE SIZE
   FILESIZE=$(ls -l $INPUTPATH/$f | awk '{print$5}')

   # ADD CURRENT FILE SIZE TO THE DIRECTORY SIZE
   DIRSIZE=$(expr "$DIRSIZE" + "$FILESIZE")

   # IF THE DIRECTORY HAS NOT YET REACHED THE MAXIMUM SIZE (optimum size: 1.6 GB)
   # TO DO: LOOP NEEDS TO STOP AND DO THE ZIP IF THE CURRENT FILESIZE IS ZERO
   # 500000000 creates zip files of 350 MB
   # 550000000 creates zip files of ??? MB
   # 600000000 createz zip files of 348-519 MB
   # 750000000 creates zip files of 571 MB
   # 1000000000 creates zip files of 700 MB
   # 2000000000 creates zip files of 1.25 GB
   # 2400000000 creates zip files of 1.55 GB
   # 2500000000 creates zip files of 1.61 GB
   # 2700000000 creates zip files of 1.75 GB
   # 3000000000 creates zip files of 1.9 GB
   # 4000000000 creates zip files of ?.? GB
#   echo "filesize $FILESIZE"
#   echo "count0x: $count"
#   echo "filecount0x: $fileCount"
   if [ $DIRSIZE -lt 550000000 ]
      then

          # CREATE A NEW DIRECTORY
          if [ ! -d "$HOMEDIR/output/$DIRNAME" ]
             then
  	             mkdir "$HOMEDIR/output/$DIRNAME"
          fi

          # COPY THE CURRENT FILE TO THE OUTPUT DIRECTORY
          cp -r "$f" "$HOMEDIR/output/$DIRNAME"
          echo
          echo "copying $f $HOMEDIR/output/$DIRNAME"

          # GET MODS
          MODS=$MODSPATH/$FILENAME.xml
          echo "modsfile = $MODS"
          if [ -f $MODS ];
             then
                # Copy the mods file
                cp $MODS $HOMEDIR/output/$DIRNAME/$FILENAME.xml
             else
                echo -e "$MODS not found..\n"
          fi
       # IF THE DIRECTORY HAS REACHED MAXIMUM SIZE
       else
           # MAKE A ZIP FILE FOR THE DIRECTORY JUST POPULATED WITH FILES
           cd $HOMEDIR/output/$DIRNAME
           for d in *
              do
                 echo 'd: = ' $d
                 zip -r $ZIPPATH/$DIRNAME.zip $d
              done
          cd ../..
          rm -rf $HOMEDIR/output/$DIRNAME

          # RESET THE DIRECTORY SIZE TO ZERO
          DIRSIZE=0

          # INCREMENT THE DIRNAME BY 1
          FLAG=$(expr $FLAG + 1)
          DIRNAME=$(printf "%04d\n" $FLAG)
          echo "=========== Creating directory: $DIRNAME =========="

          # CREATE A NEW DIRECTORY
          if ! [ -d "$HOMEDIR/output/$DIRNAME" ]
             then
  	             mkdir "$HOMEDIR/output/$DIRNAME"
          fi

          # COPY THE CURRENT FILE TO THE NEW OUTPUT DIRECTORY
          echo "f = $f"
          echo "HOMEDIR/output/DIRNAME = $HOMEDIR/output/$DIRNAME"
          cp -r "$INPUTPATH/$f" "$HOMEDIR/output/$DIRNAME"

          # GET MODS
          MODS=$MODSPATH/$FILENAME.xml
          echo "modsfile = $MODS"
          if [ -f $MODS ];
             then
                # Copy the mods file
                cp $MODS $HOMEDIR/output/$DIRNAME/$FILENAME.xml
             else
                echo -e "$MODS not found..\n"
          fi

          cd "$INPUTPATH"

   fi

done


# WHEN THE LOOP IS DONE, CREATE A ZIP FILE OF THE LAST DIRECTORY CREATED AND THEN EXIT

cd $HOMEDIR/output/$DIRNAME

for d in *
   do
      echo 'd: = ' $d
      zip -r $ZIPPATH/$DIRNAME.zip $d
      exit
   done
   cd ../..
