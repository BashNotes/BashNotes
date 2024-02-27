#!/bin/bash -e


#-#-#-#-#-#-#-# USAGE #-#-#-#-#-#-#-#-#-#
function usage {
   echo "\
#-#   A simple program for creating notes 
#-#   in vim or its forks.
#-#
#-#   Usage:
#-#      ./notes.sh NOTES_DIR
#-#"
}

#-#-#-#-#-#-# OPEN NOTES #-#-#-#-#-#-#-#-#
#-#
#-# By default, open current notes in neovim.
#-# First tab is current notes.
#-# Second tab is a diff of previous and current notes.
#-#
#-# This function can be modified to open $current_filename in any editor.
#-# Example:
#-#    function open_notes {
#-#       gedit $current_filename
#-#    }
#-#
function open_notes {
   nvim -c "\
   cd $notes_dir

   set nonumber norelativenumber
   colorscheme peachpuff

   edit $current_filename

   tab split $previous_filename
   vert diffsplit $current_filename
   tabnext 1
   "
}

#-#-#-#-#-#  DEBUG SYMBOLS  #-#-#-#-#-#-#
#-# 
# * Disable *
#!/bin/bash -e
# * Enable *
#!/bin/bash -ex

#-#-#-#-#-#-#  CLOCK FIX  #-#-#-#-#-#-#-#
#-# 
# Fix clock drift in WSL
sudo hwclock -s

#-#-#-#-#-#- NOTES DIRECTORY  #-#-#-#-#-#
#-# 
#-#  If directory argument was provided
#-#     Use provided directory as notes dir
#-#  If notes directory exists yet
#-#     Make new notes directory
#-#  Print directory being used
#-#       
notes_dir=$1
if [ $# -eq 0 ]; then
   usage
   exit
   # notes_dir="default_notes"
fi

if [ ! -d $notes_dir ]; then
   echo "Creating notes directory: $notes_dir"
   mkdir $notes_dir
fi

echo "Using \""$notes_dir"\" as the notes directory."

#-#-#-#-#-# CURRENT NOTES FILE  #-#-#-#-#
#-# 
#-# If current notes don't already exist
#-#    Get the latest note entry
#-#    If there is no latest note entry
#-#       Create a new file with the current date
#-#    Else (If there is a latest note entry)
#-#       Copy the latest note entry to the current notes
#-#       
current_filename=$(date -I)_$(date +%a).txt

if [[ ! -a $notes_dir/$current_filename ]]; then
   latest_filename=$(ls -rv $notes_dir | head -n 1)
   if [ -z $latest_filename ]; then
      echo  "Creating new notes file: " $notes_dir/$current_filename "..."
      touch $notes_dir/$current_filename
   else 
      cp $notes_dir/$latest_filename $notes_dir/$current_filename
   fi
fi

previous_filename=$(ls -rv $notes_dir | grep -m 2 "txt" | tail -n 1) # Most recent note entry before today
if [ -z $previous_filename ]; then
   previous_filename=$current_filename
fi

# Make all files except current notes read-only
chmod a-w $notes_dir/*
chmod a+w $notes_dir/$current_filename

open_notes &

# Check if it's a new day every 10 seconds
while [[ -a $notes_dir/$current_filename ]]; do
   current_filename=$(date -I)_$(date +%a).txt
   sleep 10
done
