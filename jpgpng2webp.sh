#!bin/bash
## By : Ravikant
## Date : 7 Oct 2017

# This input is image file or directory
input=$1

## change libDir as per your dir. It may be /usr/local/lib/libwebp/bin/
libDir="libwebp/bin/"

image2webp () {
echo $imageName
## image conversion by google webp lib
$libDir/cwebp -q 80 $image -o $imageName.webp
#/usr/local/lib/libwebp/bin/cwebp -q 80 $image -o $output/$imageName.webp
if [ $? != 0 ];then
        echo "Error in conversion of images"
        exit
fi
}

if [ -f $input ];then
	echo "its a file"
	image=$input
	imageName=$(echo $image | rev | cut -d'.' -f 2- | rev )
	image2webp
fi
if [ -d $input ];then
	echo "its a directory"
	for f in $input/*;do
		echo $f
		fileformat=$(file --mime-type -b $f)
		if [ -d $f ];then
			echo "its directory"
			## call recursively for dir
			sh $0 $f
			
		elif [ $fileformat = "image/png" ] || [ $fileformat = "image/jpg" ] || [ $fileformat = "image/jpeg" ];then
			echo "its a proper file format"
			echo $f
			image=$f
			imageName=$(echo $image | rev | cut -d'.' -f 2- | rev )
			echo $imageName
			image2webp
 		else
			echo "Not a valid file"
		fi
	done
fi
