#!/bin/bash
# updates: file name changed to tiffs2folders.sh (2018-01-19)
#######################
# You must put all files to be processed into the "/images" directory.
# Configure the HOME_DIR variable to hold the path of the directory that contains these directories: image and output
# Configure the "cut" (in two places) to count the number of slashes that appear in HOME_DIR.
# The function mkcp() checks forn a valid $dstdir (the "output" directory).
#   If there is no "output" directory, it creates it.
#   It also (copies (cp -r) or moves (mv) $srcfile to $dstdir, depending on which is enabled by you.
# Text from the filename is extracted up to the first underscore and is used as the directory name.
# Files containing the same core filename are written into a single directory into the "/output" directory.
# Optional: The script zips the whole directory into the "/zips" directory.
#######################
# HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/from-Marianita/civil-war-letters"
# HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Correspondence/arc-cor/Brownell/arc-cor-brnll/images/multi-sided"
# HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Prep-for-Ingest/House-of-David/spe-hod-shi"
# HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Prep-for-Ingest/Jazz/jaz-pho"
# HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Prep-for-asana/Shakers/Shaker-visual/Shaker-albums/two-sided"
# HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Reid/Sedition-folder"
# HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Prep-for-Ingest/Jazz-Photographs/jaz-pho"
HOME_DIR="/home2/lisham/diglib-15/dhiSpace/asa/phase4/images"
INPUT_DIR="$HOME_DIR/images"
# INPUT_DIR="$HOME_DIR/Binder-s10"
OUTPUT_DIR="$HOME_DIR/output"

#echo 'HOME_DIR: ' $HOME_DIR
#echo 'INPUT_DIR: ' $INPUT_DIR
#echo 'OUTPUT_DIR: ' $OUTPUT_DIR

srcdir=$INPUT_DIR

mkcp() {
   test -d "$OUTPUT_DIR/$dstdir" || mkdir -p "$OUTPUT_DIR/$dstdir"
#  cp -r $srcdir/$filename output/$dstdir
   echo -e "Copying $filename\n"
   cp $srcdir/$filename "$OUTPUT_DIR/$dstdir"
#   mv $srcdir/$filename "$OUTPUT_DIR/$dstdir"
}

for f in ${srcdir}/*
do
# STORE THE OBJECT'S CORE NAME AS THE DESTINATION DIRECTORY NAME,
# SKIPPING X PATH SEGMENTS FROM THE INPUT_DIR BY COUNTING SLASHES
# FORMULA = (NO. OF SLASHED IN HOME_DIR + 3)
   dstdir=$(echo $f | cut -f10 -d"/" | cut -f1 -d"_")

# GET THE OBJECT'S FULL FILENAME
# SKIPPING 11 PATH SEGMENTS FROM THE INPUT_DIR
   filename=$(echo $f | cut -f10 -d"/")

   echo '1 srcdir: ' $srcdir
   echo '2 dstdir: ' $dstdir
   echo '3 filename: ' $filename

   mkcp test a/b/c/d
done

# to make zip files for ingesting into existing Islandora objects
#cd output
#for d in *
#do
#   echo 'd: = ' $d
#   zip -r ../zips/$d.zip $d
#done

echo -e "Done!\n"
