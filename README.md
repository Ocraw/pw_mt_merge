Why?

Search for 'pipe' and have all the tubes right there.
If you have Modname Tooltip mod, that is.


Who?

Someone who is bad at coding.
This is a rough merge and while I didn't find any issue I can't assure
it will work as intended. Open an issue if you find one, make sure is
not an issue in Pipeworks or MoreTubes tho.


When?

When I found MoreTubes didn't work on mcl and I got tired of typing.
I commented out the sound property for mesecons and merged
moretubes into pipeworks, as a result this might only work on mcl.


How?

Download/clone this repo anywhere you like.

CARE: init.txt only contains the code to be added to
.../pipeworks/init.lua
DO NOT modify this file, the stuff written there is meant to be read
in pipeworks/init.lua.

Copy the code of this init.txt at the end of .../pipeworks/init.lua
Copy the folders 'moretubes' and 'textures' into .../pipeworks/

-OR-

Run './merge.sh [/path/to/pipeworks]'
  if no directory is specified it will default to
    $HOME/.minetest/mods/pipeworks

Done.

To disable a pipe simply comment/delete its entry in init.lua for loop.


And?

CARE: Updating Pipeworks thru CDB will reset the directory and delete the
merged files, keep this around and reapply when needed.

Once you merged properly, you can't run again merge.sh as it will read
the line "/!\ DO NOT REMOVE OR MODIFY THIS LINE /!\\" to make sure you
don't add double stuff in init.lua, you need to take care of removing all
the code added by the merge, in case you need to merge again.
Reinstall pipeworks and run merge.sh again if you are lost.

No, I won't make a merger for windows, switch to linux now.

Legal stuff:
Pipeworks is from https://github.com/mt-mods/pipeworks
MoreTubes is from https://github.com/C-C-Minetest-Server/moretubes
Their license apply, as none of the mod files are my work.
