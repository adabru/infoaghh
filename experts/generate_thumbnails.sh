#!/bin/bash

if [[ -z $1 ]]
  then echo -e "usage:\n     \e[1m. ./generate_thumbnails.sh\e[22m expert_name"
elif [[ ! -d "$1" ]]
  then echo -e "there is no folder '$1'"
elif [[ ! -d "$1/fullres" ]]
  then echo -e "folder fullres is missing"
else
  for image in $1/fullres/*; do
    name=${image##*/}
    base=$name
    base=${base%.jpg}
    base=${base%.png}
    echo $base
    convert "$1/fullres/$name" -resize 150x150 "$1/$base.jpg"
    # echo $(basename "$image")
    # echo "${image##*/}"
  done
fi
