# linimgur
  ![Muzei](http://i.imgur.com/vEFoIpw.png)

Port of [Muzei](https://github.com/romannurik/muzei/) and [MuzeiReddit](https://github.com/JordonPhillips/muzei-reddit) to Bash.
Fork of [linmuzei](https://github.com/aepirli/linmuzei).

linmgur is the lovechild of [linmuzei](https://github.com/aepirli/linmuzei) and [imgur](http://imgur.com/).
Currently supports GNU/Linux running in a Gnome-settings-daemon-based environment and Mac OSX.

## Requirements

* Bash
* GNU sed (some sed flavours do not have the -i prefix)
* cURL (for downloading stuff over the internet)
* jq (this is awesome, check it out [here](http://stedolan.github.io/jq/download/).)

## Installation

You run the script and that's it.
You can also set it as a cronjob or as an anacronjob if you want to.

## How to

You can launch it with a specific subreddit or use the default, [earthporn](https://imgur.com/r/EarthPorn/), launch it again to get a new image.
If the script can't set the wallpaper you can still find the image downloaded to ~/Pictures/imgur/Wallpapers.

###### Mac OSX
Remember to uncheck the 'Change picture' option in each display background window in which you want to set a linimgur wallpaper.
