#!/bin/bash
# updated: 2018-01-29
###########################
# Description
# For debugging use this shebang: #!/bin/bash -x
# This script creates an empty OUTPUT directory if there isn't one.
# It reads a text file (ids.txt) that has the name of one directory of TIFF files on each line.
# A loop reads the names of the files in a directory, adds each filename to list of files in a FILES variable.
# Runs a ghostscript command that combines all the files in the FILES, and runs the ghostscript command.
###########################
HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Ready-to-Ingest/spe-kor-gst"
INPUT_DIR="$HOME_DIR/images"
OUTPUT_DIR="/home2/lisham/islandora-scripts/output"

echo -e "\nINPUT_DIR= cd $INPUT_DIR\n"
echo -e "OUTPUT_DIR= $OUTPUT_DIR\n"

# Remove all files in the $OUTPUT_DIR folder (or else you may run out of disk space too soon)
#if [ -d "$OUTPUT_DIR" ]
#then
#	  echo -e "$OUTPUT_DIR does not exist"
#	  exit
    echo -e "Deleting old OUTPUT_DIR\n"
#    rm -rf "$OUTPUT_DIR"
#fi

#mkdir -p "$OUTPUT_DIR"
echo -e "Creating $OUTPUT_DIR\n"
#sleep 40s

for ID in `cat ids/ids.txt`;
do
  echo -e "ID = $ID"
#	cd "$INPUT_DIR/$ID"
#  ls -lai

	echo -e "Creating a PDF from the current directory\n"
	FILES=""

	for f in $INPUT_DIR/$ID/*
	do
		echo -e "f= $f\n"
		FILES="$FILES $f"
  done

	echo "COMMAND = tiffcp -c jpeg $FILES $OUTPUT_DIR/$ID.tif"

	tiffcp -c lzw $FILES $OUTPUT_DIR/$ID.tif
	#sleep 60s
	# tiff2pdf -r '1024x1024^' -j -q 75 -o $OUTPUT_DIR/$IDs.pdf $OUTPUT_DIR/$IDs.tif

done

echo -e "Woohoo! DONE\n"

#tiff2pdf -r '1024x1024^' -j -q 75 -o $f.pdf $f
#tiff2pdf -r '1024x1024^' -j -q 75 -o /home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Ready-to-Ingest/spe-kor-gst/images/yhm-spe-kor-gst-01-02/yhm-spe-kor-gst-01-02_s024.tif.pdf /home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Ready-to-Ingest/spe-kor-gst/images/yhm-spe-kor-gst-01-02/yhm-spe-kor-gst-01-02_s024.tif
#tiffcp -c jpeg -r 10000  /home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Ready-to-Ingest/spe-kor-gst/images/yhm-spe-kor-gst-01-02/yhm-spe-kor-gst-01-02_s023.tif, /home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Ready-to-Ingest/spe-kor-gst/images/yhm-spe-kor-gst-01-02/yhm-spe-kor-gst-01-02_s024.tif /home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Ready-to-Ingest/spe-kor-gst/images/yhm-spe-kor-gst-01-02/combines.tif


