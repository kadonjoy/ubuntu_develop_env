#!/bin/bash
while read line;
do
    filename=$(grep "$line" ./filelist);
    cp --parents -rf $filename ~/share/a7a/dualcam_driver/;
done < sync_files.log
