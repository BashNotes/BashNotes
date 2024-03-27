#-#-#-#-#-#-#-# USAGE #-#-#-#-#-#-#-#-#-
function usage {
   echo "\
   Usage:
      ./bashnotes NOTES_DIR NOTES_PROGRAM

   Summary:
      A simple program that allows you to take
      notes in your preferred text editor.

      New daily notes are created automatically
      and copy contents from the previous day.

      Argument 1: The directory where the notes 
      are/will be located.

      Argument 2: The program that the notes
      will be edited (vim, gedit, emacs, etc.).

   Example:
      ./bashnotes work_notes vim
"
}

#-#-#-#-#-#-# PROCESS ARGS #-#-#-#-#-#-#
#-# 
#-# Enforce usage, two arguments required
#-#    First argument is the directory where the notes are located
#-#    Second argument is the setting to use when opening notes
#-# Then source the notes_programs.sh script
#-# 
if [ $# -lt 2 ]; then
   usage
   exit
fi
script_location=$0
notes_dir=$1
notes_program=$2

script_dir=$(echo $script_location | grep -o ".*/")
source $script_dir/notes_programs.sh

#-#-#-#-#-# NOTES DIRECTORY #-#-#-#-#-#-
#-# 
#-# If notes directory doesn't exist, make one
#-# 
if [ ! -d $notes_dir ]; then
   echo "Creating notes directory: $notes_dir"
   mkdir $notes_dir
fi
echo "Using \""$notes_dir"\" as the notes directory."

#-#-#-#-# CURRENT NOTES FILE #-#-#-#-#-#
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


#-#-#-#-#-#-# PREVIOUS NOTES #-#-#-#-#-#
#-# 
#-# Check if notes existed from a previous day
#-# If not, use current notes as previous notes
#-# 
previous_filename=$(ls -rv $notes_dir | grep -m 2 "txt" | tail -n 1)
if [ -z $previous_filename ]; then
   previous_filename=$current_filename
fi

#-#-#-#-#-# SET PERMISSIONS #-#-#-#-#-#-
#-# 
#-# Make all files read-only, except current notes
#-# 
chmod a-w $notes_dir/*
chmod a+w $notes_dir/$current_filename

#-#-#-#-#-#-# OPEN NOTES #-#-#-#-#-#-#-#
#-#
#-# Run the notes_program specified
#-# in the arguments
#-#
$notes_program $notes_dir/$current_filename &

#-#-#-#-#-#-# NEW DAY #-#-#-#-#-#-#-#-#-
#-#
#-# Check if it's a new day every 10 seconds
#-# If it's a new day, close the script
#-#
while [[ -a $notes_dir/$current_filename ]]; do
   current_filename=$(date -I)_$(date +%a).txt
   sleep 10
done

#-#-#- RESET TERMINAL AFTER CLOSE #-#-#-
reset

#-#-#-#-#-#-# CLOCK FIX #-#-#-#-#-#-#-#-
#-# 
#-# Fix clock drift in WSL
#-# 
# sudo hwclock -s
