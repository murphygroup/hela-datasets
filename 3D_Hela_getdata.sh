#!/bin/bash

num_tgz=`ls *.tgz|wc -l`

if [ "$num_tgz" != "9" ]
then
	echo "*********************"
	echo "* LICENSE AGREEMENT *"
	echo "*********************"
	echo "All data downloaded from the Murphy Lab web site (http://murphylab.web.cmu.edu) remain the property of the 
	Murphy" 
	echo "Lab. You are granted a non-exclusive license to use these images for non-commercial, research purposes, with the" 
	echo "following conditions: (a) you agree to include a reference to"
	echo ""
	echo "M. Velliste and R.F. Murphy (2002). Automated Determination of Protein Subcellular Locations from"
	echo "3D Fluorescence Microscope Images. Proceedings of the 2002 IEEE International Symposium on Biomedical"
	echo "Imaging (ISBI 2002), pp. 867-870."
	echo ""
	echo "when presenting or publishing your results, (b) you agree to send a copy of any paper or abstract (upon its"
	echo "acceptance for publication or presentation) by FAX, email or regular mail to Dr. Murphy, and (c) you agree not to "
	echo "distribute these images without inclusion of this notice."

	echo "Dr. Robert F. Murphy"
	echo "Professor of Biological Sciences, Biomedical Engineering and Machine Learning"
	echo "Carnegie Mellon University"
	echo "4400 Fifth Ave., Pittsburgh, PA 15213"
	echo "FAX: 412-268-6571"
	echo "email: murphy@cmu.edu"

	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/3DHela_DNA.tgz
	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/3DHela_ER.tgz
	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/3DHela_Gia.tgz
	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/3DHela_Gpp.tgz
	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/3DHela_LAM.tgz
	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/3DHela_Mit.tgz
	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/3DHela_Nuc.tgz
	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/3DHela_TFR.tgz
	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/3DHela_Fac.tgz
	wget -nc http://murphylab.web.cmu.edu/data/Hela/3D/3DHela_Tub.tgz

	for FILE in 3DHela_*.tgz
	do
		echo $FILE
		tar -xf $FILE
	done
fi