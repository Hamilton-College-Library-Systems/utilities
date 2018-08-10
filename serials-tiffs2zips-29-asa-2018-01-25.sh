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
# HOME_DIR="/home2/lisham/diglib-15/LibSpace/drop-box/Ready-for-Peter/from-Metalogers/Jezreel/Pioneer-of-wisdom/spe-jez-pow"
HOME_DIR="/home2/lisham/diglib-15/dhiSpace/asa/phase4"
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

# STOP AND CREATE A ZIP FILE IF THE CURRENT ID IS zip
	if [[ ! "$ID" == "zip" ]];
	then

		# SET THE INITIAL $OUTPUT_DIR DIRECTORY NAME
		# (PADDED OUT TO 4 CHARACTERS STARTING WITH "0001"
		FLAG=1
	#	DIRNAME=$(printf "%04d\n" $FLAG)
		DIRNAME=$(printf "%03d\n" $FLAG)

		TOTAL_FILECOUNT=$( ls -l "$INPUT_DIR" | wc -l )
		echo -e "TOTAL_FILECOUNT-start = $TOTAL_FILECOUNT"
		CURRENT_FILECOUNT=0

		# PROCESS EACH FILE IN THE "INPUT_DIR" DIRECTORY
		cd "$INPUT_DIR"
#		echo "Current directory = "
#		pwd
#		ls -lai
#		echo -e "ID = [$ID]"
#		cd "$ID"
#		cd "spe-jez-pow-02-1889-09-27"
#		ls -lai
#exit;
		cd "$INPUT_DIR/$ID"

		for f in *;
		do
			echo -e "f = $f\n"
			FILETYPE="tif"
			# f (CURRENT FILENAME) MUST HAVE "tif" IN IT
			# THE if IS NOT PROPERLY ELIMINATING ".thumbs.db" FILES. SHOULD BE FIXED.
		  if [[ "$f" == *"$FILETYPE"* ]]; then

			  CURRENT_FILECOUNT=$((CURRENT_FILECOUNT+1))

			  # GET THE CURRENT FILE NAME
			  # FIELD #2 SEPARATED BY A SLASH
			  FILENAME=$(echo $f | cut -f2 -d"/")

			  # GET THE SIZE OF THE CURRENT FILE. $5 is 5th column of ls display
			  OBJECT=$(echo "$FILENAME" | cut -f1 -d"_")

			  # CREATE A NEW DIRECTORY IF NECESSARY
			  if [ ! -d "$OUTPUT_DIR/$OBJECT/$DIRNAME" ]
			  then
#  	      mkdir "$OUTPUT_DIR/$OBJECT"
				  mkdir -p "$OUTPUT_DIR/$OBJECT/$DIRNAME"

					# GET MODS
					MODS="$MODS_DIR/$OBJECT.xml"
					if [ -f "$MODS" ];
					then
						echo -e "Found $MODS\n"
						# For books copy to MODS.xml
						cp "$MODS" "$OUTPUT_DIR/$OBJECT/MODS.xml"
						# For Newspaper SP batch ingest don't rename the MODS file.
						# cp $MODS $OUTPUT_DIR/$ID/--METADATA--.xml
						#cp "$MODS $OUTPUT_DIR/$ID/--METADATA--.xml"
					else
					   echo -e "$MODS not found\n"
					   exit
					fi

					# GET PDF
					# We don't typically upload PDFs for serial issues if there are many pages, they get too big.
					# We did provide optimized PDFs for the Beinecke manuscripts
					# This routine changes a bit depending on whether the PDF is in the same dir as the TIFF (local style) or
					# all PDFs are in one "pdfs" directory (Hudson style)
					PDF="$PDFS_DIR/$OBJECT.pdf"
					if [ -f "$PDF" ];
					then
						echo -e "Found $PDF\n"
						# COPY PDF TO PDF.pdf
						echo -e "Copying $PDF to $OUTPUT_DIR/$OBJECT/PDF.pdf"
						cp "$PDF" "$OUTPUT_DIR/$OBJECT/PDF.pdf"
					else
					   echo -e "$PDF not found\n"
					#   exit;
					fi

			  else
				   # INCREMENT THE DIRNAME BY 1
				  FLAG=$(expr "$FLAG" + 1)
#						  DIRNAME=$(printf "%04d\n" "$FLAG")
				  DIRNAME=$(printf "%03d\n" "$FLAG")
				  echo "=========== Creating directory: $DIRNAME =========="

				  # CREATE A TEMPORARY DIRECTORY TO HOLD THE SCRIPT OUTPUT
				  # HOLDING THE PACKAGE STRUCTURE OF THE CURRENT OBJECT
				  if [ ! -d "$OUTPUT_DIR/$OBJECT/$DIRNAME" ] ; then
					mkdir -p "$OUTPUT_DIR/$OBJECT/$DIRNAME"
				fi

			fi

		   # COPY THE CURRENT FILE TO THE $OUTPUT_DIR DIRECTORY
		   cp -r "$f" "$OUTPUT_DIR/$OBJECT/$DIRNAME/OBJ.tif"
		   echo
		   echo -e "copying $f to $OUTPUT_DIR/$OBJECT/$DIRNAME/OBJ.tif\n"

	#       echo -e "creating Thumbnail\n"
	#       convert "$f" -thumbnail 200x225 -fuzz 1% +repage -gravity center -format jpg -quality 100 "$OUTPUT_DIR/$OBJECT/$DIRNAME/TN.jpg"

	#       echo -e "creating JPEG\n"
	#       convert -resize 800 "$f" "$OUTPUT_DIR/$OBJECT/$DIRNAME/JPG.jpg"

	#       echo -e "creating OCR\n"
	#       /usr/local/bin/tesseract "$f" "$OUTPUT_DIR/$OBJECT/$DIRNAME/OCR" -l eng

	#       echo -e "creating HOCR\n"
	#       /usr/local/bin/tesseract "$f" "$OUTPUT_DIR/$OBJECT/$DIRNAME/HOCR" -l eng hocr

				   # IF THE DIRECTORY HAS REACHED THE STOPPING POINT
				   # IF NECESSARY USE THE COMMAND LINE FOR ZIPPING: $ZIPS_DIR -r ../../zips/filename.$ZIPS_DIR *.tif
	   	else
		  # RESET THE DIRECTORY SIZE TO ZERO
##				  DIRSIZE=0

			  # INCREMENT THE DIRNAME BY 1
			  FLAG=$(expr "$FLAG" + 1)
#				  DIRNAME=$(printf "%04d\n" "$FLAG")
			  DIRNAME=$(printf "%03d\n" "$FLAG")
			  echo "=========== Creating directory: $DIRNAME =========="

			  # CREATE A NEW DIRECTORY
			  if ! [ -d "$OUTPUT_DIR/$OBJECT/$DIRNAME" ]
				then
					 mkdir "$OUTPUT_DIR/$OBJECT/$DIRNAME"
			  fi

			  # COPY THE CURRENT FILE TO THE NEW $OUTPUT_DIR DIRECTORY
			  cp -r "$f" "$OUTPUT_DIR/$OBJECT/$DIRNAME"
	    fi
		done
	else

	  # MAKE A SINGLE ZIP FILE CONTAINING EVERY DIRECTORY IN THE "output" DIRECTORY
	  # NAME THE ZIP FOR THE LAST OBJECT ADDED TO THE ZIP FILE.
		cd "$OUTPUT_DIR"

#		for d in *
#		do
#				zip -r "$ZIPS_DIR/$d.zip" "$d"
				zip -r "$ZIPS_DIR/$OBJECT.zip" *
#		done
    sleep 15s

		echo -e "removing output directory. Please wait..."
	  rm -rf "$OUTPUT_DIR"

		echo -e "Making new output directory..."
    mkdir -p "$OUTPUT_DIR"

    continue

	fi
done

echo -e "Woohoo! DONE\n"
