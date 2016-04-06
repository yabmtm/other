#!/bin/bash

#######################
# Pulls most-recently played song information from last.fm.
# Outputs text file for streaming and album cover photo updated every 10 seconds.
# Input username and API key below.
#######################

LAST_USER="llabrword"
API_KEY="7b5027d93404b121ffd4a9108fcc5b1d"

site="http://ws.audioscrobbler.com/2.0/?"\
"method=user.getrecenttracks"\
"&user=$LAST_USER"\
"&api_key=$API_KEY"\
"&limit=1"

touch .read .read_

get_info() {

    wget $site -q -O -> .packet # get last-played info

    artist=$(cat .packet | grep -m 1 artist | sed -e 's/^.*mbid//' -e 's/^.*mbid.*>//'\
        -e 's/^.*">//' -e 's/<\/artist>//') # parse for artist, album, track names
    album=$(cat .packet | grep -m 1 album | sed -e 's/<album mbid="">\(.*\)<\/album>/\1/')
    track=$(cat .packet | grep -m 1 name | sed -e 's/<name>\(.*\)<\/name>/\1/')
    echo $artist - $track # return output syntax
    sleep 5
}

check_diff() {
    cover=$(cat .packet | grep 'size="large"' | sed -e 's/<image size="large">\(.*\)<\/image>/\1/')
    if [[ $(diff .read .read_) ]] && [[ ! -z $cover ]]; then                                              │ 18:25  slinkydolp| both
        wget --no-use-server-timestamps $cover -O cover.png
	echo -n "Now playing: "
	cat .read
    fi
}

check_diff_() {
    cover=$(cat .packet | grep 'size="large"' | sed -e 's/<image size="large">\(.*\)<\/image>/\1/')
    if [[ $(diff .read .read_) ]] && [[ ! -z $cover ]]; then                                              │ 18:25  slinkydolp| both
        wget --no-use-server-timestamps $cover -O cover.png
        echo -n "Now playing: "
        cat .read_
    fi
}

while true; do
    get_info > .read; check_diff
    get_info > .read_; check_diff_
    cat .read_ >> .log
    awk '!a[$0]++' .log > scrobble.log
done
