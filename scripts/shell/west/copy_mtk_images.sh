#!/bin/bash

for file in `grep file_name: MT6763_Android_scatter.txt | cut -d ' ' -f 4`
do
    if [ ! ${file}x = 'NONE'x ]
    then
        cp MT6763_Android_scatter.txt ~/share/a7a_images/images-eng/
        cp ${file} ~/share/a7a_images/images-eng/
    fi
done
