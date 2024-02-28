#-#-#-#-#-#-# OPEN NOTES #-#-#-#-#-#-#-#
#-#
#-# More advanced notes programs.
#-# Add your own to your liking!
#-#
#-# nvimdiff:
#-#    Open current notes in neovim.
#-#    First tab is current notes.
#-#    Second tab is a diff of previous and current notes.
#-#

function nvimdiff {
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
