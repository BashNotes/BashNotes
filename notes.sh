#!/bin/bash -e
# #!/bin/bash -ex

# Fix clock drift in WSL
sudo hwclock -s

cd ~/notes/

# If daily notes were not created already, copy most recent notes to new file
export current_filename="$(date -I)_$(date +%a).txt"
export previous_filename=$(ls -rv | grep -m 1 "txt") # Most recent note entry

# If no notes for today, create today's notes from previous notes
if [[ ! -a $current_filename ]]; then
   cp $previous_filename $current_filename
fi

previous_filename=$(ls -rv | grep -m 2 "txt" | tail -n 1) # Most recent note entry before today

# Make all files except current notes read-only
chmod a-w *
chmod a+w $current_filename

# Open current notes in neovim, second tab diffs against previous notes
nvim -S open_notes.vim &

# Check if it's a new day every 10 seconds
while [[ -a $current_filename ]]; do
   export current_filename="$(date -I)_$(date +%a).txt"
   sleep 10
done
