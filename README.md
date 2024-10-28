# My NixOS Configuration
![wall](https://github.com/Rexcrazy804/Zaphkiel/blob/master/homeManagerModules/dots/sddm-wall.png?raw=true)

### What the hell have you done with home manager modules?
I couldn't find anyone that approached home manager modules in a multi user
manner with host specific configuration, thus I came up with something of my
own.

To give you a better picture, Say you've got an user with different preferences
of home manager modules across multiple hosts. What my configuration lets you
do for such an user, is to let the user enable all their preferred modules in
`homeManagerModules/homeUsers/{username}/common.nix` and selectively disable
(or enable) certain modules they wouldn't want on specfic hosts in a
corresponding `homeManagerModules/homeUsers/{hostname}.nix` file.

Any suggestions to improve this model are welcome!

### Is that it?
Well besides a really nice
[mpv.nix](https://github.com/Rexcrazy804/Zaphkiel/blob/master/homeManagerModules/programs/mpv.nix)
file that is configured to work with
[Anime4k](https://github.com/bloc97/Anime4K) Shadders. There prolly isn't
anything else worth noting about this config. That said I still have room to
work on in the system modules. I'm too lazy to work on that for the time being,
but will get it done eventaully/when the need arises :)

#### Where is that cute anime girl from?
Its ai generated (using cetusmix whalefal2), so feel free to grab it /
