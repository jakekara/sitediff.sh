#!/bin/sh
#
# sitediff.sh - diff sites
#
# config file    ~/.sitediff_config required
# archive folder ~/.sitediff_prev stores previous
#                versions of sites to diff against
#                future versions. Don't delete this
#
# SHOULD use CONFIG_FILE and PREV_FOLDER if set as
# env variables, but I haven't tested it
#
# Jake Kara, jake@jakekara.com, June 2017
#

if [ -z ${CONFIG_FILE+x} ]
then
    CONFIG_FILE=~/.sitediff_config
fi
if [ -z ${PREV_FOLDER+x} ]
then
    PREV_FOLDER=~/.sitediff_prev
fi

OLD_SUFFIX="old.html"
TMP_SUFFIX="new.html"
NEW_SUFFIX="new.html"

#
# check_setup - create the archive folder if it doesn't
#               exist already, and check for a config file
#               (exit 1  if config file doesn't exist)           
#
check_setup()
{

    if [ ! -f $CONFIG_FILE ]
    then
	echo "ERROR: Config file not found! $CONFIG_FILE"
	exit 1
    fi

    if [ ! -d $PREV_FOLDER ]
    then
	echo "CREATING $PREV_FOLDER"
	mkdir $PREV_FOLDER
    fi
}

#
# get_site get a site and save it to the "new" file
#
get_site()
{
    LINE=$1
    FNAME=`echo $LINE | sed "s/[^a-z_\.-]//g"`
    # FNAME=get_fname $LINE

    if ! curl -s $LINE -o $PREV_FOLDER/$FNAME.$NEW_SUFFIX
    then
	echo "ERROR DOWNLOADING SITE: " $LINE
	return 1
    fi

    return 0
}

#
# diff_site - compare the old site with the new one
#             if both files exist. print result.
#
diff_site()
{
    LINE=$1
    # FNAME=get_fname $1
    FNAME=`echo $LINE | sed "s/[^a-z_\.-]//g"`    

    if ! diff $PREV_FOLDER/$FNAME.$OLD_SUFFIX \
	 $PREV_FOLDER/$FNAME.$NEW_SUFFIX > /dev/null
    then
	echo "CHANGED: $LINE"	
    else
	echo "UNCHANGED: $LINE"
    fi
    
    mv $PREV_FOLDER/$FNAME.$NEW_SUFFIX $PREV_FOLDER/$FNAME.$OLD_SUFFIX
}

#
# main - process each URL in the config file
#
main()
{
    while read LINE
    do

	get_site $LINE
	diff_site $LINE
	
    done <$CONFIG_FILE
}

check_setup
main
