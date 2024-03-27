# BashNotes

## Summary
A simple program that allows you to take notes in your preferred text editor.

Daily notes are automatically created and copy contents from the previous day.

Argument 1: The directory where the notes are/will be located.

Argument 2: The program that the notes will be edited (vim, gedit, emacs, etc.).

## Usage
./bashnotes NOTES_DIR TEXT_EDITOR

## Installation
### Cloning
    git clone git@github.com:Miyelsh/BashNotes.git
### Download Zip
    unzip BashNotes-main.zip
    mv BashNotes-main BashNotes

## First Time Usage Example
    chmod +x BashNotes/bashnotes # You only need to do this once
    ./BashNotes/bashnotes example_notes vim
