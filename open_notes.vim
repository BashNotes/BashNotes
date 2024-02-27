set nonumber norelativenumber
colorscheme peachpuff

edit $current_filename

" Create new tab that diffs against previous notes
tab split $previous_filename
vert diffsplit $current_filename
tabnext 1
