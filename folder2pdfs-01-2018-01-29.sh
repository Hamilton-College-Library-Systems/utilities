#!/bin/bash -x
# updated: 2017-05-10, 2017-11-15
###########################
# Description
# For debugging use this shebang: #!/bin/bash -x
# This script is best used for creating ingest directories of issues of serials, each directory being one issue.
# The directory name must match the core part of the name of the TIFF files it contains (everything before the first underscore).
# An ids.txt file is required that contains a list of subdirectories of "images" to ingest, one subdirectory name per line.
# Instead of a directory name, you can put "zip", which tells the script to make a zip file at that point.
# The script creates a new directory for each directory (issue) and puts the new directory in a temporary directory inside the "output" directory ($OUTPUT_DIR).
# The script grabs each TIFF of an issue, creates a numbered directory for that TIFF, copies the TIFF file to it and
#   renames the TIFF file "OBJ.tif" (e.g., 001/OBJ.tif).
# WARNING: It's best to remove any files that are not ".tif" files, such as ".thumbs.db" from the images directory.
# The script finds the matching MODS file in the "mods" folder and copies it into the temporary issue directory.
# The script then looks for a matching PDF file in the "pdfs" folder. If it finds one it copies it into the temporary issue directory.
# The script can also be configured to look for a matching TEXT file in a "text" folder. If it finds one it copies it into the temporary issue directory.
# When the script encounters a "zip" line in the ids.txt file, it zips whatever directories in the "output" directory into a"zips" directory ($ZIPS_DIR).
# After each zip operation, the script resumes looping through the ids.txt file and starts the above process again until it reaches the end of the file.
# If running this script on the Vagrant image and the zip utility is not installed on the server, install it by running
#    "sudo apt-get install zip".
###########################
# HOME_DIR="/home/vagrant/diglib-15/LibSpace/drop-box/Ready-for-Metalogers/Robinson/Z-ingest-processing"
# HOME_DIR="/home/vagrant/diglib-15/LibSpace/drop-box/Ready-for-Peter/from-Metalogers/Oneida/one-ocd"
# HOME_DIR="/home/vagrant/diglib-15/LibSpace/drop-box/Ready-for-Peter/from-Metalogers/Bishop-Hill-Colony/mss"
# HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/from-Hudson/woodhull_claflin_weekly"
# HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/from-Hudson/woodhull_claflin_weekly"
HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/Ready-to-Ingest/spe-kor-gst"
INPUT_DIR="$HOME_DIR/images"
# Need to increase Vagrant's memory. Must have main object and pages for Dump module to work.
MODS_DIR="$HOME_DIR/mods"
PDFS_DIR="$HOME_DIR/pdfs"
OUTPUT_DIR="$HOME_DIR/output"
ZIPS_DIR="$HOME_DIR/zips"

echo -e "\nINPUT_DIR= cd $INPUT_DIR\n"
echo -e "OUTPUT_DIR= $OUTPUT_DIR\n"
echo -e "ZIP_DIR = $ZIPS_DIR\n"

# Remove all files in the $OUTPUT_DIR folder (or else you may run out of disk space too soon)
if [ -d "$OUTPUT_DIR" ]
then
#	  echo -e "$OUTPUT_DIR does not exist"
#	  exit
    echo -e "Deleting old OUTPUT_DIR\n"
    rm -rf "$OUTPUT_DIR"
fi
mkdir -p "$OUTPUT_DIR"
echo -e "Creating $OUTPUT_DIR\n"
#sleep 40s

for ID in `cat ids/ids.txt`;
do
  echo -e "ID = $ID"
	cd "$INPUT_DIR/$ID"
ls -lai
########## NEW PDF ROUTINE
	echo -e "creating a PDF from the current TIFF file\n"
	echo -e "f= [$f]\n"
	echo -e "PDFS_DIR/ID.pdf= [$PDFS_DIR/$ID.pdf]\n"
#echo "gs -dPDFA -dNOOUTERSAVE -dUseCIEColor -sProcessColorModel=DeviceRGB -sDEVICE=pdfwrite -o -sOUTPUTFILE=$f dPDFACompatibilityPolicy=1 $PDFS_DIR/$ID.pdf"
	// gs -dPDFA -dNOOUTERSAVE -dUseCIEColor -sProcessColorModel=DeviceRGB -sDEVICE=pdfwrite -o -sOUTPUTFILE="$f" -dPDFACompatibilityPolicy=1 "$PDFS_DIR/$ID.pdf"

########## NEW PDF ROUTINE
done

echo -e "Woohoo! DONE\n"
