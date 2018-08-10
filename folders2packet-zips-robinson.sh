#!/bin/bash
# updates: file name changed to folders2packet-zips.sh (2016-12-04)
#########################
# PURPOSE:
# To prepare zip files for ingest as required by the Islandora Batch module.(books and serials).
# Creates a directory structure required for Islandora ingest of a single book (bookCModel) or newspaper issue.
# Reads a folder containing the TIFF files for a single book or newspaper issue.
# Configure the location of the MODS and PDF files (if any).
#
# It optionally also zips the new directory structure plus the associated issue/book MODS
# file into a zip file that can be directly ingested into Islandora using the
# Islandora Newspaper Batch module. The zipping is more efficiently done manually so you
# can control the size of the zip file.
#
# DEV TO DO
# Make one variable OBJECT_TYPE (for book|serial) and let that trigger configuration settings.
# You can ingest MODS with a newspaper issue ingest packet if you ingest them with the
# Islandora Newspaper Batch module.
# Otherwise you have to ingest issue MODS files manually. Issue > Manage > Datastreams > MODS > replace.
#
# For more instructions see "excel-to-mods-steps.txt
#########################

for ID in `cat ids/ids.txt`; do
	echo $ID

	# Reset index variable - for creating folders 1..n
	index=0;
	pwd

	# SET PROJECT PATH
	# The following is the directory for processing Beinecke
	PROJECT_PATH="/hamDigital/libSpace/Peters-working-area/scripts"
	cd "$PROJECT_PATH/input/$ID"
#	pwd
# exit 0

#	cd input
#	pwd

	# Find the next directory name found in the id.txt file.
	# Find all TIFF files in the directory, sort the files, and process them one at a time.

	find *.tif -type f | sort | while IFS= read -r file; do
		# moved = Flag to indicate that the file has been moved.
		moved=0;
		# Increment index.
		((index++))

		FOLDER=$index

		# Output a directory for each TIFF file and pad the directory with extra zeros
		# as necessary to enable proper alphabetizing.

		# If the current index number is greater that 9, pad with 1 leading zeros.
		if [ $index -gt 9 ] && [ $index -le 99 ]; then
			FOLDER="0$FOLDER"
		fi
		# If index is lower than 10, add two zeros before the folder name.
		if [ $index -le 9 ]; then
			FOLDER="00$FOLDER"
		fi

		echo -e "Creating new output folder..\n"
		TARGET=../../output/$ID/$FOLDER

		mkdir -p "../../output/$ID/$FOLDER"
		# The value of moved will be 0 until the file is actually moved.

		while [ $moved -eq 0 ]; do
			# If the "output" directory has no files.
			if find "$TARGET" | read; then
				echo "$TARGET FOUND"
				# pwd

				# SET TIFF NAME
				# USE FOR BOOKS SP
				# Copy the current file to $target, rename it "OBJ.tif" and increment
				# "moved".
				 cp "$file" "$TARGET/OBJ.tif" && moved=1;

				# USE FOR Newspapers SP
				# Copy the current file to $target, do NOT rename it" and increment
				# "moved".
				# cp "$file" "$TARGET/$file" && moved=1;
				# If there are more than 10 pages then ensure that this item be the
				# last one processed

			else
				# Uncomment the line below for debugging
				echo "Directory not empty: $(find "$target" -mindepth 1)"

				# Wait for two seconds. This avoids spamming the system with
				# multiple requests.
				sleep 2;
			fi;
		done;
	done

	cd ../../
	pwd

	# Copy the corresponding MODS file and rename it "MODS.xml".
	# Check whether the MODS file exists, if not do not copy it.
	# This is required because when batch ingesting pages into objects using
	# the Newspaper SP, MODS.xml files are not ingested. They are added separately.

	# GET $ID.pdf
	PDF="input/$ID/$ID.pdf"
	if [ -f $PDF ]; then
		echo "$PDF FOUND"
	   cp $PDF output/$ID/PDF.pdf;
	   pdftotext $PDF output:output/$ID/FULL_TEXT.txt;
   fi

	# GET OBJ.pdf
	OBJPDF="input/$ID/OBJ.pdf"
	if [ -f $OBJPDF ]; then
		echo "$OBJPDF FOUND"
	   cp $OBJPDF output/$ID/OBJ.pdf;
   fi

	# GET TRANSCRIPT.txt
	TRANSCRIPT="input/$ID/TRANSCRIPT.txt"
	if [ -f $TRANSCRIPT ]; then
		echo "$TRANSCRIPT FOUND"
	   cp $TRANSCRIPT output/$ID/TRANSCRIPT.txt;
   fi

	# GET FULL_TEXT.txt
	FULLTEXT="input/$ID/FULL_TEXT.txt"
	if [ -f $FULLTEXT ]; then
		echo "$FULLTEXT FOUND"
	   cp $FULLTEXT output/$ID/FULL_TEXT.txt;
   fi

	# GET MODS
	# this routine is ignored for serials, since Islandora does not ingest serials issues
	# with MODS files.
	MODS=mods/$ID.xml
	if [ -f $MODS ];
	   then
		# For books copy to MODS.xml
		cp $MODS output/$ID/MODS.xml
		# For Newspaper SP batch ingest don't rename the MODS file.
		# cp $MODS output/$ID/--METADATA--.xml
		#cp $MODS output/$ID/--METADATA--.xml
	   else
	   echo -e "$MODS not found..\n"
	fi

	# SET ZIP
   # cd output
   # zip -r ../zips/$ID.zip $ID

done

echo -e "END OF PROGRAM..\n"

exit 0
