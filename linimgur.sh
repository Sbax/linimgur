#!/usr/bin/env bash

# linmgur is the lovechild of linmuzei (a Muzei port for the GNU/Linux 
# operating system.) and imgur. Original linmuzei code can be found on
# <http://github.com/aepirli/linmuzei>, if you're here you probably 
# know what imgur is but for the sake of convenience you can find it
# here <http://imgur.com/>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

imgurDir=~/Pictures/imgur
mkdir -p $imgurDir/Wallpaper
cd $imgurDir

gotDate=$(head -n 1 .infos)
nowDate=$(date +%Y%m%d)

sub="earthporn"
repeat=1

if [ -z "$1" ]
then
	echo "Using default subreddit earthporn, you can specify your"
	echo "preferred subreddit when launching the command"
else
	if [ $1 == "-k" ];
	then
		keep=true
		re='^[0-9]+$'
		if ! [[ $2 =~ $re ]] ; then
			sub=$2
			if [ ! -f "$3" ]
			then
				repeat=$3
			fi
		else
			repeat=$2
		fi
	else
		keep=false
		sub=$1
	fi
fi

if [ ! -f ".infos" ]
then
	i=0
else
	if [ "${gotDate}" == "${nowDate}" ] 
	then
		i=$(sed -n '2p' < .infos) 
		i=$(( i + 1 ))
		lastSub=$(sed -n '3p' < .infos) 
		if [ $i -gt 10 ]
		then
			i=0
		fi
		if [ "${lastSub}" != "${sub}" ]
		then
			i=0
		fi
	else
		i=0
	fi
	rm -f .infos
fi
echo "$(date +%Y%m%d)" >> .infos
timestamp=$(date +%s%N)

#url is being cached, appending a unique string should solve the problem
imgurl="http://imgur.com/r/"$sub"/hot/day.json?awesomevar="$timestamp

curl -s -o imgur.json $imgurl

while [ $repeat -gt 0 ]
do
	repeat=$(( repeat - 1 ))

	hashName=`jq '.data['$i'].hash' imgur.json | sed s/\"//g`
	ext=`jq '.data['$i'].ext' imgur.json | sed s/\"//g`
	nicename=`jq '.data['$i'].permalink' imgur.json | sed s/\"//g`
	nicename=$(basename "$nicename")

	title=`jq '.data['$i'].title' imgur.json | sed s/\"//g`
	imageUri="i.imgur.com/"$hashName$ext
	imageFile=$nicename$ext

	if [ "$title" == "null" ]
	then
		echo "No image found"
		exit
	fi

	echo $i" "$title

	cd Wallpaper
	if [ "$keep"  == false ]
	then
		if [ "$(ls)" ]
		then
			rm *
		fi
	fi

	if [ ! -f $imageFile ]
	then
		curl -# -o $imageFile $imageUri
	fi

	if [ $repeat != 0 ]
	then
		i=$(( i + 1 ))
	fi

	cd ..
done

function setWallpaperLinux(){
	if [ "$(pidof gnome-settings-daemon)" ]
	then
		echo "Gnome-settings-daemons detected, setting wallpaper with gsettings..."
		gsettings set org.gnome.desktop.background picture-uri file://$muzeiDir/Wallpaper/$imageFile
	else
		echo "Currently supporting only gnome, Wallpaper placed in ~/Pictures/imgur/Wallpaper"
	fi
}

function setWallpaperOSX(){
	osascript -- - "$imgurDir/Wallpaper/$imageFile" <<'EOD'
		on run(argv)
			set theFile to item 1 of argv
			tell application "System Events"
				set theDesktops to a reference to every desktop
				repeat with aDesktop in theDesktops
					set the picture of aDesktop to theFile
				end repeat
			end tell
			return
	 end
EOD
}

case "$OSTYPE" in
	linux* | *BSD*) setWallpaperLinux ;;
	darwin*)        setWallpaperOSX ;;
	*)				echo "Not able to set wallpaper under your OS, Wallpaper placed in ~/Pictures/imgur/Wallpaper"
esac

echo $i >> .infos
echo $sub >> .infos

rm -f imgur.json
