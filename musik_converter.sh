#!/bin/bash
#Musikconverter welcher schaut wieviel bitrate die datei hat und nur dann umwandelt
#benötigt mp3info & lame
########################################################################
#OPTIONEN:
maxbitrate=160

########################################################################
path=${1%/}
#path="/media/Daten2TB/Musik/TMP"
if [ -d "$path"/CONVERTED ]; then
	echo "Es exestieren noch alte Daten, bitte verschieben/löschen sie diese!"
	exit
fi

find "$path" -name "*.mp3" -print | while read line
do
	curbitrate=`mp3info -r m -p %r "$line"`
	newpath=${line/"$path"/"$path"/CONVERTED/}
	
	folderpath=`dirname "$newpath"`
	if ! [ -d "$folderpath" ]; then
		mkdir -p "$folderpath"
	fi
	if [ "$curbitrate" -gt "$maxbitrate" ];then
		echo "Converting $line"
		lame -V4 -h --quiet "$line" "$newpath"
	else
		echo "Copy $line - $curbitrate"
		cp "$line" "$newpath"
	fi
done
