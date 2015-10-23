#!/bin/bash

SH=/bin/sh

# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
	# First try to load from a user install
	source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
	# Then try to load from a root install
	source "/usr/local/rvm/scripts/rvm"
elif [[ -s "$HOME/.rbenv/bin" ]] ; then
  # try to load rbenv
  $SH -c 'export PATH="$HOME/.rbenv/bin:$PATH" ; eval "$(rbenv init -)"'
elif [[ -s `which ruby` ]] ; then
  # Nothing to do here(?)
  echo "Using system's ruby" >> ~/.argosnap/argosnap.log
else
	printf "ERROR: No ruby installation was found!\n"
fi

# Executable now should be in path
argosnap -n osx_check
