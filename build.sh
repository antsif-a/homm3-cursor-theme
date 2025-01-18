src_dir=$(realpath ./src)
cursors_dir=$(realpath ./cursors)

if [ ! -d $src_dir ]; then
    echo "Can't find sources at '$src_dir': no such file"
    exit 1
fi

mkdir -p $cursors_dir
rm -rf $cursors_dir/*

for file in $src_dir/*.cursor; do
    filename=$(basename -- "${file}")
    
    if [ ! -f "${file}" ]; then
        echo "'${file}': no such file for icon '$filename'"
    fi

    xcursorgen -p $src_dir/32 "${file}" $cursors_dir/"${filename%.*}"
    echo == $filename
done

while IFS=' ' read -ra p; do
    target=""
    for i in "${p[@]}"; do
        if [[ -z "$target" ]]; then
            target=$i
        else
            echo $target "<-" $i
            ln -s $cursors_dir/$target $cursors_dir/$i
        fi
    done
done <build.conf
