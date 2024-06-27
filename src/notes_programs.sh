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
   set nonumber norelativenumber
   colorscheme peachpuff

   edit $1
   set filetype=markdown

   tab split $2
   set filetype=markdown
   vert diffsplit $1
   tabnext 1
   "
}
