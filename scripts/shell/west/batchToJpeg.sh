#!/bin/bash
function main()
{
    for filename in $(ls *.yuv)
    do
        #echo "file name" $filename
        temp_right=${filename#*yuv}
        w_h=${temp_right%%_cnt*}
        width=${w_h%x*}
        height=${w_h#*x}
        #echo $width  $height
        ./yuv2jpeg -i ${filename} -w ${width} -h ${height}
    done
}

main
