#!/bin/bash -x
# filename: ingest-zips-on-prep-station (2017-03-03)
#########################
# Run this script on an Islandora Vagrant image.
# The script formats a drush command which performs the following actions:
# 1. It reads the filename of a zip file from a text file listing zip files 
#    that are to be ingested into Islandora.
# 2. It sends all objects (metadata plus binary objects) in the zip file 
#     into the ingest queue in Islandora.
# 3. Finally, another drush command is executed that instructs Islandora to 
#    create all the derivative datastreams that are configured for the
#    object's associated Content Model.
# The "Islandora Dump Datastream Module" (if enabled) outputs a directory for each
#   object as it is created.
# The operator can then copy the output directory to where they can then be ingested
#   into a production Islandora server, which should have derivative creation disabled.
# DATA PREPARATION:
# 1. Put the zip files to be processed into INPUT_DIR.
# 2. Enter the filenames of the zip files to be processed in the file: /ids/zip-ids.txt
# ISLANDORA PREPARATION:
# Download and enable and configure "Islandora Dump Datastream Module".
#    https://github.com/mjordan/islandora_dump_datastreams.git
# Configure admin/islandora/tools/dump_datastreams:
#    For each ingest job you have to configure the "Islandora Dump Datastream" module
#    for the exact Content Model you will be trying to ingest running this script.
#    If you select a different Content Model when you are running this script, it will fail.
# FINAL STEPS:
# If the output directories were successfully created in the Vagrants /tmp directory and
#    they were copied to the OUTPUT_DIR, then you can delete them from the /tmp directory.
# Delete the objects that were ingested into Islandora because the space on the partition
#    used for Fedora (/dev/sda1)_is limited in the Vagrant image.
#########################
# LOCAL SYSTEMS PREPARATION:
# Whenever the Islandora Vagrant image is rebuilt on this machine, you have to re-mount the
#-- "diglib-15/f$" Windows drive.
# This will be necessary also whenever the diglib-15 is not available or shows no subdirectories, or whenever
# the host computer is rebooted.
# 1. Become root: sudo su -
# 2. Run: apt-get install cifs-utils
# 3. cd /home/vagrant
# 4. mkdir diglib-15
# 5. Run: mount -t cifs -o username=pmacdona,uid=1000,gid=1000,domain=HAMILTON-D //diglib-15/f$ /home/vagrant/diglib-15
# 6. Enter Peter's domain password
#########################

# SET THE DIRECTORY WHERE THIS SCRIPT RUNS
SCRIPT_PATH=`pwd`

# SET THE DATA INPUT AND OUTPUT DIRECTORIES
TODAY_DT=$(date +%Y%m%d)
INPUT_DIR=/home/vagrant/diglib-15/LibSpace/drop-box/Ready-for-Peter/from-Metalogers/Father-Divine/New-day/zips
OUTPUT_DIR=/home/vagrant/diglib-15/LibSpace/drop-box/Ready-for-Peter/from-Metalogers/Father-Divine/New-day/derivatives_$TODAY_DT
DRUPAL_HOME=/var/www/drupal

# PROMPT USER FOR CONTENT MODEL
read -p "Select content type:
 a)Large Images
 b)Basic Images
 c)PDF
 d)Books
 e)Newspaper Issues
 f)Audio
 g)Video
 >
# :" CONTENT_MODEL

 if [ "$CONTENT_MODEL" == "a" ]; then
	CONTENT_MODEL=islandora:sp_large_image_cmodel
    PARENT=islandora:sp_large_image_collection
 elif [ "$CONTENT_MODEL" == "b" ]; then
 	CONTENT_MODEL=islandora:sp_basic_image
    PARENT=islandora:sp_basic_image_collection
 elif [ "$CONTENT_MODEL" == "c" ]; then
 	CONTENT_MODEL=islandora:sp_pdf
    PARENT=islandora:sp_pdf_collection
 elif [ "$CONTENT_MODEL" == "d" ]; then
 	CONTENT_MODEL=islandora:bookCModel
    PARENT=islandora:bookCollection
 elif [ "$CONTENT_MODEL" == "e" ]; then
 	CONTENT_MODEL=islandora:newspaperIssueCModel
    PARENT=islandora:newspaper_collection
 elif [ "$CONTENT_MODEL" == "f" ]; then
 	CONTENT_MODEL=islandora:sp-audioCModel
    PARENT=islandora:audio_collection
 elif [ "$CONTENT_MODEL" == "g" ]; then
 	CONTENT_MODEL=islandora:sp_videoCModel
    PARENT=islandora:video_collection
 else
    echo "Invalid Choice.  Figure your letters out dummy"
fi

# DISPLAY PARMETER VALUES
echo
echo "You selected the Content Model: $CONTENT_MODEL"
echo "Must be the CM configured in the Islandora Dump Datastream module menu."
echo

# PROMPT USER FOR OK TO PROCEED
echo -n "yes to proceed? (default: no): "
read OK_TO_PROCEED
if [ ! "$OK_TO_PROCEED" == "yes" ]; then
   echo "START OVER"
   exit
fi

# 1. Read the file containing names of zip files and queue them up to be ingested into Islandora.


for ID in `cat ids/zip-ids.txt`; do
   echo
   echo "PROCESSING $ID"

   cd $DRUPAL_HOME

   # 2. Place the objects in the zip file into the ingest queue in Islandora.
   # PARAMETERS AS VARIABLES
   #drush -v --user=admin --uri=http://localhost:8000 islandora_batch_scan_preprocess --content_models=$CONTENT_MODEL --namespace=demo --parent=$PARENT --parent_relationship_pred=isMemberOfCollection --type=zip --target=$INPUT_DIR/$ID

#drush -v --user=admin --uri=http://localhost:8000 islandora_batch_scan_preprocess --content_models=islandora:sp_large_image_cmodel --namespace=islandora --parent=islandora:sp_large_image_collection --parent_relationship_pred=isMemberOfCollection --type=zip --target=/home/vagrant/diglib-15/techSpace/ingest-prep/zips/

# known good for large images
#drush -v --user=admin --uri=http://localhost:8000 islandora_batch_scan_preprocess --type=zip --target="$INPUT_DIR/$ID" --content_models=islandora:sp_large_image_cmodel --namespace=prep --parent=prep:snow_hill2 --parent_relationship_pred=isMemberOfCollection 

# newspaper issues
echo "target=$INPUT_DIR/$ID"

drush -v --user=admin --uri=http://localhost:8000 islandora_newspaper_batch_preprocess --type=zip --target="$INPUT_DIR/$ID" --namespace=newday --parent=islandora:1 --create_pdfs --aggregate_ocr

# known good
#drush -v --user=admin --uri=http://localhost:8000 islandora_batch_scan_preprocess --content_models=islandora:sp_large_image_cmodel --namespace=prep --parent=prep:snow_hill --parent_relationship_pred=isMemberOfCollection --type=zip --target=/tmp/0006.zip

done

   #drush -v --user=admin --uri=http://localhost:8000 islandora_batch_scan_preprocess --namespace=prep --content_models=islandora:sp_large_image_cmodel --parent=islandora:sp_large_image_CModel --parent_relationship_pred=isMemberOfCollection --type=zip --target=/tmp/$ID
# 3. Instruct Islandora to create all derivative datastreams.

drush -v --user=admin --uri=https://localhost:8000 islandora_batch_ingest

# 4. Copy the ingested objects datastreams from the "dump" directory (Drupal /tmp directory) into an derivatives directory.

if [ ! -d $OUTPUT_DIR ]
    then
        mkdir $OUTPUT_DIR
fi

echo "... Copying files to $OUTPUT_DIR ..."
cp -r /tmp/prep_* $OUTPUT_DIR

echo -e "END OF PROGRAM..\n"
