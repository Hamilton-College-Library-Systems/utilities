#!/bin/bash
#######################
# Zips each directory into a separate zip file
#######################
HOME_DIR="/home2/lisham/diglib-15/LibSpace/CDM-Migration/sparc/IMI-Archives-Publications/arc-pub-cat/catalogs/output"
cd $HOME_DIR
for d in *
do
   echo 'd: = ' $d
   zip -r ../zips/$d.zip $d
done

echo -e "Done!\n"
