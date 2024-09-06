#!/bin/sh

_ledir="$1"
__CHECK='/!\ DO NOT DELETE OR MODIFY THIS LINE /!\'

if ! [ -r ./init.txt ] || ! [ -r ./moretubes ] ||
    ! [ -r ./textures ]; then
  echo "--[ It seems you are in the wrong directory
    or have no read access to the needed files. Exiting."
  exit 1
fi

if [ -z "$_ledir" ]; then
  _ledir="$HOME/.minetest/mods/pipeworks"
  while true; do
    read -p "--[ Directory autoselected: $_ledir Continue?" yn
    case $yn in
      [Nn]* ) echo "--[ Exiting."; exit 1;;
      [Yy]* ) break;;
      * ) echo "--[ Answer y[es]/n[o]";;
    esac
  done
  echo "--[ Autoselecting ${_ledir}\n    If this fails specify pipeworks directory."
fi

if ! [ -d "$_ledir" ]; then
  echo "--[ $_ledir is not a valid directory. Exiting."
  exit 1
elif ! [ -w "${_ledir}/init.lua" ] || ! [ -w "${_ledir}/textures" ]; then
  echo "--[ Couldn't find ${_ledir}/init.lua or ${_ledir}/textures\n \
    or you have no write access. Check directory again. Exiting."
  exit 1
else
  if grep -q -F "$__CHECK" "${_ledir}/init.lua"; then
    echo "--[ You already ran a merge.
    If not working either reinstall pipeworks and re-merge or manually fix."
    exit 0
  else
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
  fi
fi
