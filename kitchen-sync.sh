#!/usr/bin/bash

# variables
my_name=backyard
my_today=$(date +"%Y%m%d")
my_sync="${my_name}-${my_today}"
my_pi="pico-henry"
my_remote_user=$(whoami) # mine is the same!
my_remote="~/sky-photos/$my_sync/"
my_proj="${HOME}/Projects/20230311-image-test/"
my_local="$my_proj/images/$my_sync"
my_fix="${my_local}-fix"
my_movie_dir="$my_proj/movies"
my_movie="${my_movie_dir}/${my_sync}.mp4"

# sync from my pi
rsync -auv "${my_remote_user}@${my_pi}:${my_remote}" "$my_local"

# fix borders
julia --project=${my_proj} \
	${my_proj}/remove-all-borders.jl \
	${my_local}

# run ffmpeg and output to my_movie dir
mkdir -p "$my_movie_dir"
yes | ffmpeg -framerate 30 \
	-pattern_type \
	glob -i "${my_fix}/*.jpg" \
	-vcodec libx264 \
	-crf 17 \
	-preset ultrafast \
	"${my_movie}"

# show the result
xdg-open "${my_movie}"
