#!/bin/bash -x

# Test his script on a vagrant image before using on productions.
# INSTRUCTIONS
# Comment out the _DRUPAL_HOME environment variable you do not need.
# Enable only the Islandora core and basic modules, not all modules.
# Modules listed as "Modules included" do not need to be deleted. They are part of a parent module.

# SET ENVIRONMENT VARIABLES
VAGRANT_DRUPAL_HOME=/var/www/drupal
#OSS_DRUPAL_HOME=~/public_html
UPDATE_EXEC_DIR=`pwd`

# MAKE DIRECTORIES TO HOLD BACKUPS
TODAY=$(date +"%y-%m-%d")
LIBBAK=~/libraries-bak-$TODAY
MODBAK=~/modules-bak-$TODAY
SITESBAK=~/sites-bak=$TODAY

if ! [ -d "$LIBBAK" ]; then
   sudo rm -rf $LIBBAK
fi

if ! [ -d "$MODBAK" ]; then
   sudo rm -rf $MODBAK
fi

if ! [ -d "$SITESBAK" ]; then
   sudo rm -rf $SITESBAK
fi
mkdir $LIBBAK
mkdir $MODBAK
mkdir $SITESBAK

# Change directory to Drupal Home
#OSS_DRUPAL_HOME=~/public_html
cd $VAGRANT_DRUPAL_HOME

#drush status
drush @sites -y cache-clear all

# DO AN ARCHIVE DUMP (Drupal, mySQL, and default site)
# @sites doesn't work with archive-dump.
# You can list all sites separately, or just cp them after running archive-dump
drush archive-dump
# Automatic default destination: ~/drush-backups/archive-dump/[date]nnnnnn/drupal7.[date].tar.gz

# TAKE ALL SITES OFFLINE
drush @sites -y variable-set --exact maintenance_mode 1

echo "** Making backups of modules and libraries..."

cp -a sites/all/modules/* $MODBAK/
cp -a sites/all/libraries/*  $LIBBAK/
cp -a sites/*.hamilton.edu  $SITESBAK/

echo

###########################
echo "** DISABLING ISLANDORA ESSENTIAL MODULES..."
drush @sites dis -y islandora
drush @sites dis -y objective_forms
drush @sites dis -y islandora_basic_collection
drush @sites dis -y islandora_basic_image
drush @sites dis -y islandora_large_image
drush @sites dis -y islandora_pdf
echo

echo "** DISABLING ISLANDORA SUPPLEMENTAL MODULES..."
drush @sites dis -y islandora_bagit
drush @sites dis -y islandora_usage_stats
drush @sites dis -y islandora_collection_search
drush @sites dis -y islandora_solr_views
drush @sites dis -y islandora_solr_metadata
drush @sites dis -y islandora_solr
drush @sites dis -y islandora_solr_config
drush @sites dis -y islandora_premis
drush @sites dis -y islandora_checksum_checker
drush @sites dis -y islandora_checksum
drush @sites dis -y islandora_bookmark
drush @sites dis -y islandora_videojs
drush @sites dis -y islandora_pdfjs
drush @sites dis -y islandora_newspaper
drush @sites dis -y islandora_binary_object
drush @sites dis -y islandora_manuscript
drush @sites dis -y islandora_ead
drush @sites dis -y islandora_paged_tei_seadragon
drush @sites dis -y islandora_rest
drush @sites dis -y islandora_audio
drush @sites dis -y islandora_video
drush @sites dis -y zip_importer
drush @sites dis -y islandora_importer
drush @sites dis -y islandora_newspaper_batch
drush @sites dis -y islandora_book_batch
drush @sites dis -y islandora_batch, islandora_batch_report
drush @sites dis -y islandora_book
drush @sites dis -y islandora_internet_archive_bookreader
drush @sites dis -y islandora_paged_content
drush @sites dis -y islandora_compound_object
drush @sites dis -y islandora_large_image
drush @sites dis -y islandora_marcxml
drush @sites dis -y islandora_ocr
drush @sites dis -y islandora_xacml_editor
drush @sites dis -y islandora_xacml_api
drush @sites dis -y islandora_openseadragon
drush @sites dis -y islandora_fits
drush @sites dis -y islandora_oai
drush @sites dis -y islandora_basic_image
drush @sites dis -y islandora_basic_collection
drush @sites dis -y objective_forms
drush @sites dis -y xml_forms
drush @sites dis -y xml_form_api, xml_form_builder, xml_form_elements, xml_schema_api
drush @sites dis -y islandora
drush @sites dis -y xml_schema_api
drush @sites dis -y php_lib
drush @sites dis -y islandora_solution_pack_entities
drush @sites dis -y islandora_solution_pack_web_archive
drush @sites dis -y islandora_badges
drush @sites dis -y islandora_populator
drush @sites dis -y islandora_simple_workflow
drush @sites dis -y islandora_xmlsitemap
drush @sites dis -y islandora_solr_facet_pages
drush @sites dis -y islandora_google_scholar
drush @sites dis -y islandora_scholar_embargo
drush @sites dis -y islandora_scholar
drush @sites dis -y islandora_find_replace
drush @sites dis -y islandora_datastream_crud
drush @sites dis -y islandora_disk_image
drush @sites dis -y islandora_example_simple_text
drush @sites dis -y islandora_pathauto

# DISABLE CONTRIB MODULES
drush @sites dis -y islandora_example_simple_text
drush @sites dis -y islandora_webform_ingest
drush @sites dis -y islandora_webform
drush @sites dis -y islandora_gsearcher
drush @sites dis -y islandora_transcript
drush @sites dis -y transcripts_ui
drush @sites dis -y islandora_oralhistories
drush @sites dis -y islandora_pretty_text_diff
drush @sites dis -y islandora_plupload
drush @sites dis -y islandora_solr_collection_view
drush @sites dis -y islandora_serial_object
drush @sites dis -y islandora_solution_pack_xml
drush @sites dis -y islandora_map_browse
drush @sites dis -y islandora_themekey
drush @sites dis -y icu
drush @sites dis -y idu
drush @sites dis -y islandora_form_fieldpanel
drush @sites dis -y islandora_blocks
drush @sites dis -y islandora_context
drush @sites dis -y islandora_batch_with_derivs
drush @sites dis -y islandora_streaming
drush @sites dis -y islandora_dump_datastreams
drush @sites dis -y plupload
echo

###########################
echo "** Updating Libraries Needed by Islandora Modules..."

#Change to libraries directory
cd sites/all/libraries/

sudo rm -rf tuque
git clone https://github.com/Islandora/tuque.git
echo

#sudo rm -rf BagItPHP
git clone https://github.com/scholarslab/BagItPHP.git
echo

#sudo rm -rf citeproc-php
git clone https://github.com/Islandora/citeproc-php.git
echo

sudo rm -rf plupload
git clone -b 1.x https://github.com/moxiecode/plupload.git
echo

sudo rm -rf jQuery.PrettyTextDiff
git clone https://github.com/arnab/jQuery.PrettyTextDiff.git
echo

sudo rm -rf jstree
git clone https://github.com/vakata/jstree.git
echo

# Update videojs
sudo rm -rf video-js
git clone https://github.com/videojs/video.js.git
sudo mv ./video.js ./video-js
# Or Run the following on a preinstalled Islandora instance
#drush -v videojs-plugin (does not work)
#echo

# Update Leaflet [Routine not yet finished]
#sudo rm -rf ?????
#git https://github.com/?????/?????.git
#mkdir leaflet
#cd leaflet
# Download the zip file of "Leaflet.js-v.0.7.7".
# Unzip "Leaflet.js-v.0.7.7"
#mkdir ../Leaflet.markercluster-leaflet-0.7
#cd ../Leaflet.markercluster-leaflet-0.7
# Download the zip file for "Leaflet Marker Cluster".
# Unzip "Leaflet.markercluster-leaflet-0.7"
echo

###########################

# THE FOLLOWING SHOULD NOT NEED TO BE RUN.

# NON-ISLANDORA LIBRARIES USED (both work)
drush -v iabookreader-plugin
drush -v colorbox-plugin

# IF YOU NEED TO UPDATE THE FOLLOWING LIBRARIES
# TRY COPYING THE DIRECTORY FROM A WORKING SYSTEM
# INSTEAD OF INSTALLING THEM YOURSELF

# Update pdfjs (THIS IS NOT GETTING THE RIGHT FILES.)
#sudo rm -rf pdfjs
#git clone git://github.com/mozilla/pdf.js.git
#sudo mv ./pdf.js ./pdfjs
# Or Run the following on a preinstalled Islandora instance
#drush pdfjs-plugin
#echo

# Update openseadragon(THIS IS NOT GETTING THE RIGHT FILES.)
#sudo rm -rf openseadragon
# Run the following on a preinstalled Islandora instance
#drush openseadragon-plugin
#echo

###########################
echo "** DELETING ISLANDORA FOUNDATION MODULES..."

cd $VAGRANT_DRUPAL_HOME/sites/all/modules/

sudo rm -rf islandora
sudo rm -rf islandora_badges
sudo rm -rf islandora_bagit
sudo rm -rf islandora_batch
sudo rm -rf islandora_book_batch
sudo rm -rf islandora_bookmark
sudo rm -rf islandora_checksum
sudo rm -rf islandora_checksum_checker
sudo rm -rf islandora_fits
sudo rm -rf islandora_form_fieldpanel
sudo rm -rf islandora_importer
sudo rm -rf islandora_internet_archive_bookreader
sudo rm -rf islandora_marcxml
sudo rm -rf islandora_newspaper_batch
sudo rm -rf islandora_oai
sudo rm -rf islandora_ocr
sudo rm -rf islandora_openseadragon
sudo rm -rf islandora_paged_content
sudo rm -rf islandora_pathauto
sudo rm -rf islandora_pdfjs
sudo rm -rf islandora_premis
sudo rm -rf islandora_populator
sudo rm -rf islandora_scholar
sudo rm -rf islandora_simple_workflow
sudo rm -rf islandora_solr_facet_pages
sudo rm -rf islandora_solr_metadata
sudo rm -rf islandora_solr_search
sudo rm -rf islandora_solr_views
sudo rm -rf islandora_solution_pack_audio
sudo rm -rf islandora_solution_pack_book
sudo rm -rf islandora_solution_pack_collection
sudo rm -rf islandora_solution_pack_compound
sudo rm -rf islandora_solution_pack_disk_image
sudo rm -rf islandora_solution_pack_entities
sudo rm -rf islandora_solution_pack_image
sudo rm -rf islandora_solution_pack_large_image
sudo rm -rf islandora_solution_pack_newspaper
sudo rm -rf islandora_solution_pack_pdf
sudo rm -rf islandora_solution_pack_video
sudo rm -rf islandora_solution_pack_web_archive
sudo rm -rf islandora_usage_stats
sudo rm -rf islandora_videojs
sudo rm -rf islandora_xacml_editor
sudo rm -rf islandora_xml_forms
sudo rm -rf islandora_form_fieldpanel
sudo rm -rf islandora_xmlsitemap
sudo rm -rf objective_forms
sudo rm -rf php_lib

echo "** UPDATING ISLANDORA FOUNDATION MODULES..."

# Islandora/islandora_bookmark
#-- Modules included: islandora_bookmark_csv_exports
# Islandora/islandora_importer
#-- Modules included: zip_importer
# Islandora/islandora_scholar
#-- Modules included: bibliography, bibutils, citeproc, csl,
#  islandora_doi, doi_importer, doi_populator,
#  islandora_endnotexml, endnotexml_importer, doi_populator,
#  citation_exporter,
#  islandora_google_scholar, islandora_scholar_embargo,
#  islandora_pmid, pmid_importer, pmid_populator
#  islandora_ris, rid_importer, ris_populator
# Islandora/islandora_solr_search
#-- Modules included: islandora_solr_config
# Islandora/islandora_solution_pack_compound
#-- Modules included: islandora_compound_object_zip_importer
# Islandora/islandora_solution_pack_entities
#-- Modules included: islandora_entities_csv_import
# Islandora/islandora_xml_forms
#-- Modules included: xml_form_builder, xml_form_api, xml_form_elements, islandora_test_cm

git clone git://github.com/Islandora/islandora.git
git clone git://github.com/Islandora/islandora_badges.git
git clone git://github.com/Islandora/islandora_bagit.git
git clone git://github.com/Islandora/islandora_batch.git
git clone git://github.com/Islandora/islandora_book_batch.git
git clone git://github.com/Islandora/islandora_bookmark.git
git clone git://github.com/Islandora/islandora_checksum.git
git clone git://github.com/Islandora/islandora_checksum_checker.git
git clone git://github.com/Islandora/islandora_fits.git
git clone git://github.com/Islandora/islandora_importer.git
git clone git://github.com/Islandora/islandora_form_fieldpanel.git
git clone git://github.com/Islandora/islandora_internet_archive_bookreader.git
git clone git://github.com/Islandora/islandora_marcxml.git
git clone git://github.com/Islandora/islandora_newspaper_batch.git
git clone git://github.com/Islandora/islandora_oai.git
git clone git://github.com/Islandora/islandora_ocr.git
git clone git://github.com/Islandora/islandora_openseadragon.git
git clone git://github.com/Islandora/islandora_paged_content.git
git clone git://github.com/Islandora/islandora_pathauto.git
git clone git://github.com/Islandora/islandora_pdfjs.git
git clone git://github.com/Islandora/islandora_premis.git
git clone git://github.com/Islandora/islandora_populator.git
git clone git://github.com/Islandora/islandora_scholar.git
git clone git://github.com/Islandora/islandora_simple_workflow.git
git clone git://github.com/Islandora/islandora_solr_facet_pages.git
git clone git://github.com/Islandora/islandora_solr_metadata.git
git clone git://github.com/Islandora/islandora_solr_search.git
git clone git://github.com/Islandora/islandora_solr_views.git
git clone git://github.com/Islandora/islandora_solution_pack_audio.git
git clone git://github.com/Islandora/islandora_solution_pack_book.git
git clone git://github.com/Islandora/islandora_solution_pack_collection.git
git clone git://github.com/Islandora/islandora_solution_pack_compound.git
git clone git://github.com/Islandora/islandora_solution_pack_disk_image.git
git clone git://github.com/Islandora/islandora_solution_pack_entities.git
git clone git://github.com/Islandora/islandora_solution_pack_image.git
git clone git://github.com/Islandora/islandora_solution_pack_large_image.git
git clone git://github.com/Islandora/islandora_solution_pack_newspaper.git
git clone git://github.com/Islandora/islandora_solution_pack_pdf.git
git clone git://github.com/Islandora/islandora_solution_pack_video.git
git clone git://github.com/Islandora/islandora_solution_pack_web_archive.git
git clone git://github.com/Islandora/islandora_usage_stats.git
git clone git://github.com/Islandora/islandora_videojs.git
git clone git://github.com/Islandora/islandora_xacml_editor.git
git clone git://github.com/Islandora/islandora_xml_forms.git
git clone git://github.com/Islandora/islandora_form_fieldpanel.git
git clone git://github.com/Islandora/islandora_xmlsitemap.git
git clone git://github.com/Islandora/objective_forms.git
git clone git://github.com/Islandora/php_lib.git

##########################

# COPY CUSTOM TRANSFORMS

#- ??? add the MODS v3.5 mods_to_dc_oai stylesheet
#sudo mv islandora_oai/transforms/mods_to_dc_oai.xsl islandora_oai/transforms/mods_to_dc_oai.xsl.3.4
#cp $UPDATE_EXEC_DIR/transforms/mods_to_dc_oai.xsl islandora_oai/transforms/

#- ??? add the MODS v3.5 mods_to_dc stylesheet
#sudo mv islandora_batch/transforms/mods_to_dc.xsl islandora_batch/transforms/mods_to_dc.xsl.3.4
#cp $UPDATE_EXEC_DIR/transforms/mods_to_dc.xsl islandora_batch/transforms/

#- ??? add the MODS v3.5 mods_to_dc stylesheet
#sudo mv islandora_importer/xsl/mods_to_dc.xsl islandora_importer/xsl/mods_to_dc.xsl.3.4
#cp $UPDATE_EXEC_DIR/transforms/mods_to_dc.xsl islandora_importer/xsl/

# UPDATE CONTRIB/LOCAL MODULES

#- Islandora-Labs/islandora_binary_object
#- Modules included: islandora_binary_object_zip_importer
sudo rm -rf islandora_binary_object
git clone git://github.com/Islandora-Labs/islandora_binary_object

#- Islandora-Labs/islandora_solr_collection_view
sudo rm -rf islandora_solr_collection_view
git clone git://github.com/Islandora-Labs/islandora_solr_collection_view

#- yorkulibraries/islandora_transcript
sudo rm -rf islandora_transcript
git clone git://github.com/yorkulibraries/islandora_transcript

#- islandora_batch_report (included in islandora_batch)

#- CommonMedia - islandora_webform
#- Modules included: islandora_webform_ingest, islandora_example_simple_text
sudo rm -rf islandora_webform
git clone git://github.com/commonmedia/islandora_webform.git

#- digitaluts - islandora_solution_pack_oralhistories
# Modules included: transcripts_ui
sudo rm -rf islandora_solution_pack_oralhistories
git clone git://github.com/digitalutsc/islandora_solution_pack_oralhistories

#- contentmath islandora_pretty_text_diff
sudo rm -rf islandora_pretty_text_diff
git clone git://github.com/contentmath/islandora_pretty_text_diff

#- contentmath - islandora_find_replace
sudo rm -rf islandora_find_replace
git clone git://github.com/contentmath/islandora_find_replace

#- DigitalGrinnell/icu
sudo rm -rf icu
git clone git://github.com/DigitalGrinnell/icu

#- DigitalGrinnell/idu
sudo rm -rf idu
git clone git://github.com/DigitalGrinnell/idu

#- discoverygarden islandora_collection_search
sudo rm -rf islandora_collection_search
git clone git://github.com/discoverygarden/islandora_collection_search

#- discoverygarden islandora_paged_tei_seadragon
#- Modules included: islandora_paged_content
sudo rm -rf islandora_paged_tei_seadragon
git clone git://github.com/discoverygarden/islandora_paged_tei_seadragon

#- discoverygarden islandora_rest
sudo rm -rf islandora_rest
git clone git://github.com/discoverygarden/islandora_rest

#- discoverygarden islandora_solution_pack_manuscript
sudo rm -rf islandora_solution_pack_manuscript
git clone git://github.com/discoverygarden/islandora_solution_pack_manuscript

#- discoverygarden/islandora_gsearcher
sudo rm -rf islandora_gsearcher
git clone git://github.com/discoverygarden/islandora_gsearcher

#- discoverygarden/islandora_plupload
sudo rm -rf islandora_plupload
git clone git://github.com/discoverygarden/islandora_plupload

#- discoverygarden/islandora_solution_pack_serial
#- Modules included: islandora_serial_object_zip_pdf_importer
sudo rm -rf islandora_serial_object
git clone git://github.com/discoverygarden/islandora_solution_pack_serial

#- DrexelUniversityLibraries/islandora_solution_pack_ead
sudo rm -rf islandora_solution_pack_ead
git clone git://github.com/DrexelUniversityLibraries/islandora_solution_pack_ead

#- echidnacorp/islandora_blocks
sudo rm -rf islandora_blocks
git clone git://github.com/echidnacorp/islandora_blocks

#- mjordan/islandora_context
sudo rm -rf islandora_context
git clone git://github.com/mjordan/islandora_context

#- mjordan/islandora_solution_pack_xml
#- Modules included: islandora_simple_xml_batch, islandora_simple_xml_context
#- islandora_solution_pack_xml_derivatives_example, islandora_simple_xml_viewer
sudo rm -rf islandora_solution_pack_xml
git clone git://github.com/mjordan/islandora_solution_pack_xml

#- mjordan/islandora_themekey
sudo rm -rf islandora_themekey
git clone git://github.com/mjordan/islandora_themekey

#- mjordan/islandora_batch_with_derivs
sudo rm -rf islandora_batch_with_derivs
git clone git://github.com/mjordan/islandora_batch_with_derivs

#- mjordan - islandora_datastream_crud
sudo rm -rf islandora_datastream_crud
git clone git://github.com/mjordan/islandora_datastream_crud

#- mjordan/islandora_dump_datastreams
sudo rm -rf islandora_dump_datastreams
git clone git://github.com/mjordan/islandora_dump_datastreams

#- jyobb/islandora_map_browse
sudo rm -rf islandora_map_browse
git clone git://github.com/jyobb/islandora_map_browse

#- rosiel/islandora_solution_pack_streaming_media
sudo rm -rf islandora_solution_pack_streaming_media
git clone git://github.com/rosiel/islandora_solution_pack_streaming_media

echo

###########################
#- DRUPAL CONTRIB MODULES (for periodic updating)

# drush dl --yes ctools
# drush dl -y libraries
# drush dl -y views
# drush dl -y token
# drush dl -y xmlsitemap
# drush dl --yes coder --select --choice=1
 drush dl --yes plupload

###########################
#- ISLANDORA CONTRIB MODULES NOT INSTALLED
#- ????? mjordan islandora_scg (Sample Content Generator)
##sudo rm -rf islandora_scg
##git clone git://github.com/mjordan/islandora_scg
echo

###########################
# ENABLE ISLANDORA FOUNDATION & CONTRIB MODULES USED BY MOST SITES

cd $VAGRANT_DRUPAL_HOME

drush @sites en -y islandora
drush @sites en -y islandora_basic_collection
drush @sites en -y objective_forms
drush @sites en -y islandora_basic_image
drush @sites en -y islandora_pdf
drush @sites en -y php_lib
drush @sites en -y islandora_large_image
drush @sites en -y xml_form_api, xml_form_builder, xml_form_elements, xml_schema_api
drush @sites en -y xml_forms
drush @sites en -y islandora_fits
drush @sites en -y islandora_ocr
drush @sites en -y islandora_openseadragon
drush @sites en -y islandora_batch
drush @sites en -y islandora_importer
drush @sites en -y zip_importer
drush @sites en -y islandora_internet_archive_bookreader
drush @sites en -y islandora_paged_content
drush @sites en -y islandora_book
drush @sites en -y islandora_book_batch
drush @sites en -y islandora_batch_report
drush @sites en -y islandora_compound_object
drush @sites en -y islandora_solr
drush @sites en -y islandora_solr_views
drush @sites en -y islandora_solr_metadata
drush @sites en -y islandora_videojs
drush @sites en -y islandora_pdfjs
drush @sites en -y islandora_premis
drush @sites en -y islandora_checksum
drush @sites en -y islandora_checksum_checker
drush @sites en -y islandora_newspaper
drush @sites en -y islandora_collection_search
drush @sites en -y islandora_newspaper_batch
drush @sites en -y islandora_bagit
drush @sites en -y islandora_solr_facet_pages
drush @sites en -y islandora_google_scholar
drush @sites en -y islandora_scholar_embargo
drush @sites en -y islandora_scholar
drush @sites en -y islandora_find_replace
drush @sites en -y islandora_datastream_crud
drush @sites en -y plupload
drush @sites en -y islandora_plupload
drush @sites en -y islandora_marcxml
drush @sites en -y islandora_form_fieldpanel
drush @sites en -y islandora_audio
drush @sites en -y islandora_video
drush @sites en -y islandora_gsearcher
drush @sites en -y islandora_example_simple_text
drush @sites en -y islandora_webform
drush @sites en -y islandora_webform_ingest

# ENABLE CONTRIB UTILITIES USED BY MOST SITES
drush @sites en -y icu
drush @sites en -y idu
drush @sites en -y islandora_batch_with_derivs
drush @sites en -y islandora_dump_datastreams
drush @sites en -y islandora_pretty_text_diff
drush @sites en -y islandora_serial_object

# ENABLE ADDITIONAL MODULES AS NEEDED PER SITE
#drush en -y islandora_badges
#drush en -y islandora_binary_object
#drush en -y islandora_blocks
#drush en -y islandora_bookmark
#drush en -y islandora_context
#drush en -y islandora_disk_image
#drush en -y islandora_ead
#drush en -y islandora_entities
#drush en -y islandora_manuscript
#drush en -y islandora_map_browse
#drush en -y islandora_oai
#drush en -y islandora_oralhistories
#drush en -y islandora_paged_tei_seadragon
#drush en -y islandora_pathauto
#drush en -y islandora_populator
#drush en -y islandora_rest
#drush en -y islandora_simple_workflow
#drush en -y islandora_solr_collection_view
#drush en -y islandora_solution_pack_xml
#drush en -y islandora_streaming
#drush en -y islandora_themekey
#drush en -y islandora_transcript
#drush en -y islandora_usage_stats
#drush en -y islandora_web_archive
#drush en -y islandora_xacml_api
#drush en -y islandora_xacml_editor
#drush en -y islandora_xmlsitemap
#drush en -y transcripts_ui
#drush en -y plupload
#drush en -y xml_form_api
#drush en -y zip_importer
echo

###########################

cd $VAGRANT_DRUPAL_HOME
drush @sites cache-clear all -y
drush @sites updatedb -y

echo "** BRINTING DRUPAL SITES BACK ONLINE..."
drush @sites variable-set -y --exact maintenance_mode 0

