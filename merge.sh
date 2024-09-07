#!/bin/sh

_ledir="$1"
__CHECK='-- /!\ DO NOT DELETE OR MODIFY THIS LINE /!\'

if ! grep -V >/dev/null 2>&1 || ! cat --version >/dev/null 2>&1; then
  echo "--[ You are missing grep or cat, install them to use this script."
  exit 1
fi

if ! [ -r ./init.txt ] || ! [ -r ./moretubes ] ||
    ! [ -r ./textures ]; then
  echo "--[ It seems you are in the wrong directory
    or have no read access to the needed files. Exiting."
  exit 1
fi

if [ -z "$_ledir" ]; then
  _ledir="$HOME/.minetest/mods/pipeworks"
  while true; do
    echo "--[ Directory autoselected: $_ledir"
    read -p "    Continue? [y/n] " yn
    case "$yn" in
      [Nn]* ) echo "--[ Exiting."; exit 0;;
      [Yy]* ) break;;
      * ) echo "--[ Answer y[es]/n[o]";;
    esac
  done
  echo "--[ Autoselecting ${_ledir}
    If this is the wrong directory, add the right one after the command."
fi

if ! [ -d "$_ledir" ]; then
  echo "--[ $_ledir is not a valid directory. Exiting."
  exit 1
elif ! [ -w "${_ledir}/init.lua" ] || ! [ -w "${_ledir}/textures" ]; then
  echo "--[ Couldn't find ${_ledir}/init.lua or ${_ledir}/textures\n
    or you have no write access. Check directory again. Exiting."
  exit 1
else
  if ! grep -q -F -- "$__CHECK" "${_ledir}/init.lua"; then
    echo "--[ Merging now!"
    if cp -v -R ./moretubes "$_ledir" &&
       cp -v -R ./textures "$_ledir" &&
       echo "--[ Catting init.txt >> ${_ledir}/init.lua" &&
       cat ./init.txt >> "${_ledir}/init.lua"; then
       echo "--[ Seems all went fine. Enjoy!"
       exit 0
    else
      echo "--[ Something went wrong, every man for himself!"
      exit 1
    fi
  else
    echo "--[ You already ran a merge.
    If not working either reinstall pipeworks and re-merge or manually fix."
    exit 0
  fi
fi
