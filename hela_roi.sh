#!/bin/bash

for filename in `find . -name *.ome.tif`
do
    filename="${filename:2}"
    echo "$filename"
    fname=$(basename "$filename")
    fname1=${fname%.*}
    xmlname="$(dirname "$filename")/${fname1%.*}.xml" 
    echo $xmlname
    echo "Creating xml..."
    ./tiffcomment $filename > $xmlname

    FILE=$xmlname

	sed -i '' 's|<AnnotationRef.*/></Image>|ULANI</Image>|g' $FILE
	./xmlindent $FILE > new.txt
	grep "TagAnnotation" new.txt | cut -d"=" -f2 | cut -d">" -f1 | cut -d"<" -f1 | tr -d '\n' | sed 's/ //g' | tr '""' '"\n"' > temp.txt
	awk 'NF' temp.txt > tags.txt

	rm temp.txt

	sed -i '' 's|:|~|g' tags.txt

	STRING=''
	for ID in  $(cat tags.txt)
	do
	    STRING=$STRING'<AnnotationRef xmlns="http\://www.openmicroscopy.org/Schemas/SA/2015-01" ID="'$ID'"/>'
	done


	sed -i '' "s|ULANI|$STRING|g" $FILE

	sed -i '' "s|~|\\:|g" $FILE

	rm new.txt

    sed -i '' 's|<ImagingEnvironment>.*</ImagingEnvironment>|<ImagingEnvironment/>|g' $xmlname
    sed -i '' 's|<ROI xmlns="http://www.openmicroscopy.org/Schemas/ROI/2015-01" ID=".*"><Union>|<ROI xmlns="http://www.openmicroscopy.org/Schemas/ROI/2015-01" ID="ROI:0"><Union>|g' $xmlname
    sed -i '' 's|<ROIRef xmlns="http://www.openmicroscopy.org/Schemas/ROI/2015-01" ID=".*"/><AnnotationRef|<ROIRef xmlns="http://www.openmicroscopy.org/Schemas/ROI/2015-01" ID="ROI:0"/><AnnotationRef|g' $xmlname
    sed -i '' 's|points0||g' $xmlname
    sed -i '' 's|<Polygon Points="|<Polygon Points="points0|g' $xmlname
    echo "Replacing with fixed xml..."
    ./tiffcomment -set "$xmlname" $filename
    rm "${xmlname}"
done
