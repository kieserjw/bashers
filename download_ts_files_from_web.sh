#!/bin/bash

# Takes in a URL of a m3u[8] file (and optionally a name for the video)
# Downloads the ts files and combines them into a final video for easy uploading/converting

if [ $# -eq 2 ]; then
    playlistURL=$1
    video_name=$2
    playlistName=$video_name'.m3u8'
elif [ $# -eq 1 ]; then
    playlistURL=$1
    playlistName=${playlistURL##*/}
    video_name=${playlistName%%.*}
else
    echo "Usage: ${0} URL_of_m3u[8] [video_name]"
    exit 1
fi

mkdir -p bin/$video_name


wget -O bin/$playlistName $playlistURL

sed -i 's/^#EXT.*$//g' bin/$playlistName
sed -i '/^$/d' bin/$playlistName

while read line; do
  wget -q -P bin/$video_name $line
done < bin/$playlistName

pushd bin/$video_name
for a in [0-9]*.ts; do
    mv $a `printf %09d.%s ${a%.*} ${a##*.}`
done

popd
cat bin/$video_name/* > bin/$video_name.ts

