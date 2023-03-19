#!/usr/bin/env sh

# set defaults
mydir=$(pwd)
myname=capture
myrepeats=1
mysleep=10

# explain what will happen
print_usage() {
  printf "capture-sky.sh
  Usage: 
  Take one or more photos in a sequence.

  Flags with arguments:
    -d directory: where the output will go (defaults to current dir, and
       will create if it does not exist) 
    -n name: the base name of the output file (defaults to 'capture')
    -r repeats: the number of images to take (defaults to 1)
    -s sleep: the sleep between each successive image (defaults to 10)

  Flags without arguments:
    -h print this help message
"
}

# parse optional arguments
while getopts d:n:r:s:h flag
do
    case "${flag}" in
        d) mydir=${OPTARG};;
        n) myname=${OPTARG};;
        r) myrepeats=${OPTARG};;
        s) mysleep=${OPTARG};;
        h) print_usage
           exit 1;;
        *) print_usage
           exit 1;;
    esac
done

# let the user know what will happen
echo "output directory: $mydir"
echo "output file name: $myname"
echo "number of shots: $myrepeats"
echo "sleep between repeats: $mysleep"

# ensure that the output directory exists
mkdir -p $mydir

# take photos until we're done!
i=1
while [ $i -le $myrepeats ]
do
    mynow=$(date +"%Y-%m-%d-%H%M%S")
    echo "Capturing image $i/$myrepeats at $mynow."
    libcamera-jpeg --immediate -t 1 -o $mydir/$myname-$mynow.jpg
    i=$(($i+1))
    if [ $myrepeats -gt 1 ] 
    then
      echo "Sleeping for $mysleep seconds."
      sleep $mysleep
    fi
done
