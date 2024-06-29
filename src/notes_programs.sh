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
   noremap <C-p> :w<Enter>:!./bashnotes personal_notes<Enter>
   noremap <C-e> :w<Enter>:!./bashnotes effect_notes<Enter>

   set nonumber norelativenumber
   colorscheme peachpuff

   edit $1

   tab split $2
   vert diffsplit $1
   wincmd h
   tabnext 1
   "
}

function nvim_notes {
   nvim -c "\
   noremap <C-p> :w<Enter>:!./bashnotes personal_notes<Enter>
   noremap <C-e> :w<Enter>:!./bashnotes effect_notes<Enter>

   set nonumber norelativenumber
   colorscheme peachpuff

   edit $1
   "
}
