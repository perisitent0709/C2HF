#!/bin/bash
###A script to generate POTCAR according to POSCAR
###Revised on 2015-10-21
## Peng Wang

filein=POSCAR

[ ! -f "$filein" ] && echo "NO POSCAR exist" && exit 1

####Convert POSCAR to unix format##
format=$(file $filein)
if [ "$format" != "$filein: ASCII text" ]; then 
	echo "$filein is DOS format" 
	dos2unix $filein 
	echo "Convert to UNIX format"
else 
	echo "$filein is UNIX format"
fi

####get the path##  
filepath=$(cd "$(dirname "$0")"; pwd)
rm -f POTCAR

####generate POTCAR##
i=1
j=$(sed -n '6 p' $filein | awk '{print $'$i'}')
while [ "$j" != "" ]
do
	echo "Element: $j" 
	cat "$filepath"/"$j"/POTCAR >>POTCAR
	i=$(($i+1))
	j=$(sed -n '6 p' $filein | awk '{print $'$i'}')
done

exit 0
