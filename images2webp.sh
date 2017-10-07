#!bin/bash
## By : Ravikant
## Date : 7 Oct 2017

input=$1
output=$2

if [ $# -eq 0 ] || [ $# -eq 1 ];then
        echo "please pass valid arguments"
        echo "first argument for image folder/file and second argument for where you want to save webp images"
        exit
fi

## Check output directory when not exit then create it
if [ -d $output ];then
        echo "output directory availabe"
else
        echo "output directory not exit"
        mkdir -p $output
fi

image2webp () {
echo $imageName
## image conversion by google webp lib
libwebp/bin/cwebp -q 80 $image -o $output/$imageName.webp
if [ $? != 0 ];then
        echo "Error in conversion of images"
        exit
fi

}

## Check image file type when passed argument is file type then it convert to webp
if [ -f $input ];then
        image=$input
	imageName=$(echo "$image" | rev | cut -d'.' -f 2- | rev)
        echo "Its a file type"
        image2webp
        exit
fi
### Check passed argument . when it is directory and contains multiple images than it compress one by one.
if [ -d $input ];then
        echo "its a directory"
        mkdir -p $output/$input
        for f in $input/*; do
        	if [ -d $f ];then
			echo "directory"
			sudo sh $0 $f $output
		else
			if [ $(file --mime-type -b $f) = 'image/png' ] || [ $(file --mime-type -b $f) = 'image/jpg' ] || [ $(file --mime-type -b $f) = 'image/jpeg' ];then
				echo "valid images file"
				echo "File -> $f"
                        	image=$f
                        	imageName=$(echo "$image" | rev | cut -d'.' -f 2- | rev)
                        	image2webp
			
			else 	      
		  		echo "File -> $f"
				echo "not valid file"
			fi
		fi
        done

        exit
fi
 
