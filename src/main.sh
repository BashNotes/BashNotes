#-#-#-#-#-#-#-# USAGE #-#-#-#-#-#-#-#-#-
function usage {
   echo "\
   Usage:
      ./bashnotes NOTES_DIR [NOTES_PROGRAM]

   Summary:
      A simple program that allows you to take
      notes in your preferred text editor.

      New daily notes are created automatically
      and copy contents from the previous day.

      Argument 1: The directory where the notes 
      are/will be located.

      Argument 2: The program that the notes
      will be edited (vim, gedit, emacs, etc.).

      If argument 2 is not provided, Bashnotes 
      will sync but not open an editor.

   Example:
      ./bashnotes work_notes vim
"
}

#-#-#-#-#-#-# PROCESS ARGS #-#-#-#-#-#-#
#-# 
#-# Enforce usage, first arguments required
#-#    First argument is the directory where the notes are located
#-#    Second argument is the setting to use when opening notes
#-# 
if [ $# -lt 1 ]; then
   usage
   exit
fi
notes_dir=$1
notes_program=$2

# Sync notes before changes
git checkout notes
git pull -q origin notes
git restore -q --staged .

#-#-#-#- SOURCE NOTES PROGRAMS #-#-#-#-#
#-# 
#-# Source the notes_programs.sh script
#-# 
source src/notes_programs.sh

#-#-#-#-#-# NOTES DIRECTORY #-#-#-#-#-#-
#-# 
#-# If notes directory doesn't exist, make one
#-# 
if [ ! -d $notes_dir ]; then
   echo "Creating notes directory: $notes_dir"
   mkdir $notes_dir
fi
echo "Using \""$notes_dir"\" as the notes directory."

if [ ! -d $notes_dir/daily_notes ]; then
   echo "Creating daily_notes directory: $notes_dir/daily_notes"
   mkdir $notes_dir/daily_notes
fi
echo "Using \""$notes_dir/daily_notes"\" as the daily notes directory."

#-#-#-#-# CURRENT NOTES FILE #-#-#-#-#-#
#-# 
#-# If current notes don't already exist
#-#    Get the latest note entry that ends in .md
#-#    If there is no latest note entry
#-#       Create a new file with the current date
#-#    Else (If there is a latest note entry)
#-#       Copy the latest note entry to the current notes
#-#
current_daily_notes=$(date -I)_$(date +%a).md

if [[ ! -a $notes_dir/daily_notes/$current_daily_notes ]]; then
   latest_filename=$(ls -rv $notes_dir/daily_notes | grep ".md" | head -n 1)
   if [ -z $latest_filename ]; then
      echo  "Creating new notes file: " $notes_dir/daily_notes/$current_daily_notes "..."
      touch $notes_dir/daily_notes/$current_daily_notes
   else 
      cp $notes_dir/daily_notes/$latest_filename $notes_dir/daily_notes/$current_daily_notes
   fi
fi


#-#-#-#-#-#-# PREVIOUS NOTES #-#-#-#-#-#
#-# 
#-# Check if notes existed from a previous day
#-# If not, use current notes as previous notes
#-# 
previous_daily_notes=$(ls -rv $notes_dir/daily_notes/ | grep -m 2 ".md" | tail -n 1)
if [ -z $previous_daily_notes ]; then
   previous_daily_notes=$current_daily_notes
fi

#-#-#-#-#-# SET PERMISSIONS #-#-#-#-#-#-
#-# 
#-# Make all files read-only, except current notes
#-# 
chmod a-w $notes_dir/daily_notes/*
chmod a+w $notes_dir/daily_notes/$current_daily_notes

#-#-#-#-#-#-# CREATE SYMLINKS #-#-#-#-#-#-#-#
#-#
#-# Go to notes directory and create symbolic links for current and previous notes
#-#
cd $notes_dir/daily_notes
rm .*.md || true # remove all previous symlinks
current_daily_notes_symlink=.$current_daily_notes
previous_daily_notes_symlink=.$previous_daily_notes
ln -f -s $current_daily_notes  $current_daily_notes_symlink
ln -f -s $previous_daily_notes $previous_daily_notes_symlink
cd $OLDPWD

#-#-#-#-#-#-# OPEN NOTES #-#-#-#-#-#-#-#
#-#
#-# Run the notes_program specified
#-# in the arguments
#-#
if [ $# -gt 1 ]; then
   $notes_program $notes_dir/daily_notes/$current_daily_notes_symlink $notes_dir/daily_notes/$previous_daily_notes_symlink
fi

# Sync notes after changes
git add $notes_dir
git commit -m "$notes_dir synced at $(date -Im)" && echo "$notes_dir synced at $(date -Im)"
git push origin notes
git checkout -q @{-1}
