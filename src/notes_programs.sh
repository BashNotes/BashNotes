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
   set filetype=markdown

   tab split $previous_filename
   set filetype=markdown
   vert diffsplit $current_filename
   tabnext 1

   cd ..
   "
}
