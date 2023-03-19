using Images
using FileIO
using ImageView


function process_all(img_dir_in)
    # get the input image directory
    img_dir_in_split = split(img_dir_in, "/") |> (l -> filter(x -> (length(x) > 0), l))
    img_dir_out = join(vcat(img_dir_in_split[1:(end-1)], img_dir_in_split[end] * "-fix/"), "/")
    img_dir_out = (img_dir_in[1] == '/') ? ("/" * img_dir_out) : img_dir_out
    all_imgs = readdir(img_dir_in) |> sort! |> l -> filter(x -> split(x, ".")[end] == "jpg", l)
    println(length(all_imgs))

    # get one image (all same dims)
    img_path = img_dir_in * "/" * all_imgs[1]
    img = load(img_path)

    # get dim information from the first image
    y,x = size(img)
    excess = x - y
    shift = 0
    left_side = 1 + excess÷2 + shift
    right_side = x - excess÷2 + shift

    # build the mask
    R = y÷2
    img_cropped = @view img[:, left_side:right_side]
    mask = zeros(Bool, size(img_cropped))
    for i = 1:y
        for j = 1:y
            if sqrt((R-i)^2+(R-j)^2) >= R
               mask[i,j] = 1
             end
        end
    end

    # iterate over the images
    mkpath(img_dir_out)
    for orig_file_name in all_imgs
        in_path  = img_dir_in * "/" * orig_file_name
        out_path = img_dir_out * "/" * orig_file_name

        # read mask and write
        if !isfile(out_path)
            println("----------------------------------------")
            println("Fixing:")
            println(in_path)
            println(out_path)
            println("----------------------------------------")
            img = load(in_path)
            img_cropped = @view img[:, left_side:right_side]
            img_cropped[mask] .= 0
            save(out_path, reverse(reverse(img_cropped, dims=1), dims=2))
        end
    end
end


# if we are interactive, run the script. the only arg
# allowed is the path-name
if abspath(PROGRAM_FILE) == @__FILE__
    if length(ARGS) == 0
        print("Whoops")
    elseif length(ARGS) == 1
        println("Processing $(ARGS[1])")
        process_all(ARGS[1])
    end
end
