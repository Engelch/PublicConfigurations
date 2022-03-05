This directory contains the profiles that I use when working on a Mac.

The 0? profiles are for working on the local host.
The 1? profiles are for working on development (remote) machines.
The 2? profiles are for working in Quality and Testing environments.
The 3? profiles are for working in PRODUCTIVE environments.

Unfortunately, Mac Terminal only offers the possbility to export/import
a profile one by one.
Instead, I copied here the comp.apple.Terminal.plist file which contains
all the above profiles which is to be copied to ~/Library/Preferences. 
This can result in a hen and egg situation and you might need a second
terminal emulator like iTerm to install it.
Be aware with iTerm: in 2021, hackers tried to inject malicious code
into iterm.

CE 2022-03
