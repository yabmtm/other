#!/bin/bash

movie_list=$(find -regextype egrep -type f -iregex '.*\.(avi|mpg|mov|flv|wmv|asf|mpeg|m4v|divx|mp4|mkv)$')

for movie in $movie_list; do
    echo $movie
    exiftool $movie | grep "Image Size"
done
