declare -a arr1=("DNA" "Fac" "Gia" "LAM" "Nuc" "ER_" "Gpp" "Mit" "Tub")
# declare -a arr1=("DNA")

if [ ! -d "images" ]
then
	mkdir images
else
	rm -rf images
	mkdir images
fi

for folder1 in "${arr1[@]}"
do
	echo ++++++++ current dataset: $folder1
	arr2=($(ls -d ${folder1}/*/))
	for folder2 in "${arr2[@]}"
	do
		if [ "$folder2" != "${folder1}/raw/" ]; then #cell1,cell2...

			folder3=${folder2}cell/
			echo -------- current cell: $folder3
			#count planes, get file name
			arr3=($(ls ${folder3}))
			count=`ls $folder3|wc -l`
			count2="$(echo -e "${count}" | tr -d '[:space:]')"
			IFS='.' read -ra file_name_split <<< "${arr3[0]}"

			#convert tif to ometiff
			./bftools/bfconvert -stitch "${folder3}${file_name_split[0]}.z<1-${count2}>.tif" ${folder2}${file_name_split[0]}_1.ome.tif
			folder3=${folder2}dna/
			# echo $folder3
			./bftools/bfconvert -stitch "${folder3}${file_name_split[0]}.z<1-${count2}>.tif" ${folder2}${file_name_split[0]}_2.ome.tif
			folder3=${folder2}prot/
			# echo $folder3
			./bftools/bfconvert -stitch "${folder3}${file_name_split[0]}.z<1-${count2}>.tif" ${folder2}${file_name_split[0]}_3.ome.tif
			folder3=${folder2}crop/
			# echo $folder3
			./bftools/bfconvert "${folder3}${file_name_split[0]}.mask1.tif" ${folder2}${file_name_split[0]}_4.ome.tif

			#combine ometiff
			filename_part1=`echo "$folder2"|sed 's/\//_/g'`
			./bftools/bfconvert -stitch "${folder2}${file_name_split[0]}_<1-4>.ome.tif" ./images/${filename_part1}${file_name_split[0]}.ome.tif

			#modify ometiff header
			./bftools/tiffcomment ./images/${filename_part1}${file_name_split[0]}.ome.tif > ${folder2}ome_temp.xml
			./bftools/xmlindent ${folder2}ome_temp.xml>${folder2}ome_temp_indent.xml
			if [ -f ${folder2}ome_temp_replace.xml ]; then
				rm ${folder2}ome_temp_replace.xml
			fi
			while read p; do
				str=$p
				# echo $str
				if [[ $p =~ "SizeC=\"1\" SizeT=\"4\"" ]]
				then
					str="${p/SizeC=\"1\" SizeT=\"4\"/SizeC=\"4\" SizeT=\"1\"}"
					# echo $str
				fi
				if [[ $p =~ "FirstC=\"0\" FirstT=\"1\"" ]]
				then
					str="${p/FirstC=\"0\" FirstT=\"1\"/FirstC=\"1\" FirstT=\"0\"}"
					# echo $str
				fi
				if [[ $p =~ "FirstC=\"0\" FirstT=\"2\"" ]]
				then
					str="${p/FirstC=\"0\" FirstT=\"2\"/FirstC=\"2\" FirstT=\"0\"}"
					# echo $str
				fi
				if [[ $p =~ "FirstC=\"0\" FirstT=\"3\"" ]]
				then
					str="${p/FirstC=\"0\" FirstT=\"3\"/FirstC=\"3\" FirstT=\"0\"}"
					# echo $str
				fi
				echo $str >> ${folder2}ome_temp_replace.xml
			done < ${folder2}ome_temp_indent.xml
			./bftools/tiffcomment -set "${folder2}ome_temp_replace.xml" ./images/${filename_part1}${file_name_split[0]}.ome.tif
			echo -------- modify ./images/${filename_part1}${file_name_split[0]}.ome.tif header complete !
		fi
		# break
	done
done


                 
      