#!/bin/bash
#################
# Be sure these directories exist: in your $HOME_DiR:
# tiffs - put your TIFF files here that you want to made a thumbnail from
# tns - this is where the script will write the jpeg thumbnail file
#################
HOME_DIR="/home2/lisham/diglib-15/dhiSpace/apw/2018-06-13-batch-7"
SOURCE_DIR="$HOME_DIR/tiffs"
OUTPUT_DIR="$HOME_DIR/tns"

echo "HOME_DIR=$HOME_DIR"
echo "SOURCE_DIR=$SOURCE_DIR"
echo "OUTPUT_DIR=$OUTPUT_DIR"

cd "$SOURCE_DIR"

for f in *;
	do
	echo "f = $f"

	# GET THE CORE NAME OF THE CURRENT FILE -- MINUS THE EXTENSION
     FILENAME="${f%%.*}"

	# echo "FILENAME = $FILENAME"
	# echo -e "creating $FILENAME.jpg in $OUTPUT_DIR/$FILENAME.jpg\n"

	convert "$f" -thumbnail 200x225 -fuzz 1% +repage -gravity center -format jpg -quality 100 "$OUTPUT_DIR/$FILENAME.jpg"

	#       echo -e "creating JPEG\n"
	#       convert -resize 800 "$f" "$OUTPUT_DIR/$OBJECT/$DIRNAME/JPG.jpg"

	#       echo -e "creating OCR\n"
	#       /usr/local/bin/tesseract "$f" "$OUTPUT_DIR/$OBJECT/$DIRNAME/OCR" -l eng

	#       echo -e "creating HOCR\n"
	#       /usr/local/bin/tesseract "$f" "$OUTPUT_DIR/$OBJECT/$DIRNAME/HOCR" -l eng hocr

	#       echo -e "creating HOCR\n"
	#       /usr/local/bin/tesseract "$f" "$OUTPUT_DIR/$OBJECT/$DIRNAME/HOCR" -l eng hocr

done