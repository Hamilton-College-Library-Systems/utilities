#!/bin/bash
#######################
# Zips each directory into a separate zip file
# Be sure to creatg a "/zips" folder parallel to the HOME_DIR.
#######################
HOME_DIR="/home2/lisham/diglib-15/LibSpace/CDM-Migration/cwl/IMI-Civil-War-TEI/spe-civ-adm/obj_files-obsolete/multiple-images"
cd $HOME_DIR

for d in *
do
   echo 'd: = ' $d
   zip -r ../zips/$d.zip $d
done

echo -e "Done!\n"
