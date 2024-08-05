# BashNotes

## Summary
A simple program that allows you to take notes in your preferred text editor.

New daily notes are created automatically and copy contents from the previous day.

Cloning this repository allows you to use git as a version control offline.

Forking this repository to a private allows you to use GitHub (or whatever you prefer) to host the notes in a repository, viewable and editable anywhere.

If you prefer, you can simply use this program to create daily notes, but ignore the git/GitHub integration entirely.



## Usage
```
    Usage:
        ./bashnotes NOTES_DIR [OPTIONS] [NOTES_PROGRAM]

    Argument 1: The directory where the notes are/will be located.
    Argument 2: The program that the notes will be edited (vim, gedit, emacs, etc.).
    If argument 2 is not provided, Bashnotes will sync but not open an editor.

    Options:
        -o/--offline  Skip pull and push of git repository
        -s/--skip-git Skip using git entirely

    Included Notes Programs
        nvim_notes: Open neovim with peachpuff color scheme 
            and a weekly planner.
        nvim_diff: Open neovim with peachpuff color scheme,
            a weekly planner, and a diff with the previous day.

    Add your own notes program with aliases or bash functions.
    For instance:
        alias vim_notes="vim -c \"set nonumber norelativenumber\""
        ./bashnotes notes_dir vim_notes

    Examples:
        ./bashnotes work_notes vim
        ./bashnotes evil_notes emacs
        ./bashnotes notes_directory --skip-git nvim_diff
        ./bashnotes notes_directory --offline nvim_notes
```

## Installation and Usage
### Option 1: Fork and Clone
First, fork this repository to your GitHub account, or whatever preferred host that you have. Preferably, make it private so only you can view your notes.

#### Example using GitHub:
```
git clone git@github.com:<username>/BashNotes.git
git remote add upstream git@github.com:BashNotes/BashNotes.git # Add BashNotes/BashNotes as the upstream, in case you want to make a pull request
cd BashNotes
./bashnotes.sh notes_dir vim
```

### Option 2: Cloning this repository
#### Example using GitHub:
```
git clone git@github.com:BashNotes/BashNotes.git
cd BashNotes
./bashnotes.sh notes_dir --offline vim # You can't push your branch to BashNotes/BashNotes
```

### Option 3: Download Zip and use with or without git
```
unzip BashNotes-main.zip
mv BashNotes-main BashNotes
cd BashNotes
./bashnotes.sh notes_dir --skip-git gedit
