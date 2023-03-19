#!/usr/bin/bash

# defaults
my_root=${HOME}/sky-photos/
my_name=capture
today=$(date +"%Y%m%d")
my_repeats=720
my_sleep=10

# explain what will happen
print_usage() {
  printf "capture-sky.sh
  Usage:
  Take one or more photos in a sequence.

  Flags with arguments:
    -d root directory: parent directory of the directory where the output
       will go (defaults to current dir, will create if it does not
       exist)
    -n name: the base name of the output file (defaults to 'capture')
    -r repeats: the number of images to take (defaults to 720)
    -s sleep: the sleep between each successive image (defaults to 10)

  Flags without arguments:
    -h print this help message
"
}

while getopts d:n:r:s:h flag
do
    case "${flag}" in
        d) my_root=${OPTARG};;
        n) my_name=${OPTARG};;
        r) my_repeats=${OPTARG};;
        s) my_sleep=${OPTARG};;
        h) print_usage
           exit 1;;
        *) print_usage
           exit 1;;
    esac
done

# make the parent if it doesn't exist
my_output=$my_root/$my_name-$today/
mdkir -p $my_output

# run the capture loop
$HOME/capture-sky.sh -d $my_output \
    -n $my_name \
    -r $my_repeats \
    -s $my_sleep
