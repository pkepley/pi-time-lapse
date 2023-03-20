# pi-time-lapse

This repository contains a handful of bash and Julia scripts for generating MPEG files from time-lapses that I've taken on a Raspberry Pi W2. 
Two of the scripts are deployed on my Pi, while the remaining scripts are executed locally.

## *Remote* Pi Scripts
The Pi's time-lapse capture is executed using the script `capture-sky.sh`, and the script `run-me.sh` is a wrapper with some "sensible" presets which I can run without having to set any flags (e.g. for a `cron` or `at` job).

## *Local* Synthesis Scripts
My "local" machine stitches the time-lapse videos together.
The post-processing script `remove-all-borders.jl` is used to mask, crop, and rotate each image (I *could* have used Image Magick, but that would have required more reading, and it was easy enough to implement in Julia).
Although I *could* wait for the Pi to run its whole sequence before generating a time-lapse, in practice I want to see results earlier. 
As such, the script `kitchen-sync.sh` is a wrapper that will `rsync` the Pi's images to my local device, run the Julia post-processing script, stitch the video together with FFmpeg, and then display the result.
