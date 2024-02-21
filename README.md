# Toy Story Patches
This repo contains various patches for Disney's Toy Story. For now, only the US SNES version is supported.

### Level Editor
**EDITOR.ASM** is an in-game level editor.

## How to use
These ASM patches are meant to be used with a [patch assembler](http://infinitefactors.org/jonk/patch.html). 
The work-flow can be set-up this way:
  - Extract the patch assembler into some folder.
  - Put MAIN.ASM and LABELS_US.ASM in the same folder.
  - Put a ROM file of SNES Toy Story in the same folder as well and rename it to TS1.SMC.
  - Run "asmpatch.exe TOYLINK.M32", preferably through a command line so that any potential errors are visible. You can also drag the linker file onto the executable.
  - A secondary rom file TS2.SMC should now have been created, this is the patched ROM file.
