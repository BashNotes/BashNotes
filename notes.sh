#!/bin/bash -ex

#-#-#-#-#-#-# INTRODUCTION  #-#-#-#-#-#-#
#-# A simple program for creating notes 
#-# in vim or its forks.
#-# 
#-# Usage:
#-#    ./notes.sh [NOTES_DIR]

#-#-#-#-#-#  DEBUG SYMBOLS  #-#-#-#-#-#-#
# * Disable *
#!/bin/bash -e
# * Enable *
#!/bin/bash -ex

#-#-#-#-#-#-#  CLOCK FIX  #-#-#-#-#-#-#-#
# Fix clock drift in WSL
sudo hwclock -s

#-#-#-#-#-#- NOTES DIRECTORY  #-#-#-#-#-#
#-#  If [ no arguments when script was run ]
#-#     If [ default notes directory exists yet ]
#-#        Make new directory called $default_notes
#-#  Else (directory argument was provided)
#-#      Use provided directory as notes dir
#-#  Print directory being used
#-#       
export notes_dir=default_notes
optional_notes_dir=$1
if [ -z $optional_notes_dir ]; then
   if [ ! -d default_notes ]; then
      echo "Creating default notes directory: default_notes"
      mkdir default_notes
   fi
else
   notes_dir=$optional_notes_dir
fi

echo "Using \""$notes_dir"\" as the notes directory."

#-#-#-#-#-# CURRENT NOTES FILE  #-#-#-#-#
#-# If current notes don't already exist
#-#    Get the latest note entry
#-#    If there is no latest note entry
#-#       Create a new file with the current date
#-#    Else (If there is a latest note entry)
#-#       Copy the latest note entry to the current notes
#-#       
export current_filename=$(date -I)_$(date +%a).txt

if [[ ! -a $notes_dir/$current_filename ]]; then
   latest_filename=$(ls -rv $notes_dir | head -n 1)
   if [ -z $latest_filename ]; then
      echo  "Creating new filee: " $notes_dir/$current_filename "..."
      touch $notes_dir/$current_filename
   else 
      cp $notes_dir/$latest_filename $notes_dir/$current_filename
   fi
fi

export previous_filenam=$(ls -rv | grep -m 2 "txt" | tail -n 1) # Most recent note entry before today
if [ -z $previous_filename ]; then
   previous_filename=$current_filename
fi

# Make all files except current notes read-only
chmod a-w $notes_dir/*
chmod a+w $notes_dir/$current_filename

# Open current notes in neovim, second tab diffs against previous notes
# Uses $notes_dir, $current_filename, and $previous_filename
nvim -S open_notes.vim &

# Check if it's a new day every 10 seconds
while [[ -a $notes_dir/$current_filename ]]; do
   current_filename=$(date -I)_$(date +%a).txt
   sleep 10
done
