#!/bin/bash

rm cscope*
#rm ctags
find ./ -path "./legacy" -prune -o -name "*.h" -o -name "*.c" -o -name "*.cpp" > cscope.files
echo "finished to create files"
python optimize_cscopefiles.py cscope.files > cscope_tmp.txt
while read line
do
    grep $line cscope.files | grep "mt6763" >> cscope_tmp_files.txt
    line1="${line//\//\\/}"
    #echo $line1
    sed -i '/'"$line1"'/d' cscope.files
done < cscope_tmp.txt

cat cscope_tmp_files.txt >> cscope.files
sed -i '/[Tt]est/d' cscope.files
rm cscope*.txt
cscope -bkq -i cscope.files
echo "finished to build cscope index"
ctags -R *
echo "finished to build ctags"
