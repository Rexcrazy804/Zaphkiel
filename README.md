# My NixOS Configuration
![screenshot-16-3-25](https://github.com/user-attachments/assets/bd237307-2e6a-495d-a7dc-fa6e4b824599)
- wallpaper: [lingsha by ATDAN-](https://www.pixiv.net/en/artworks/123071255)

#### What have you done?
Initially I had ditched home-manager for wrapping programs myself
this worked quite well in my favour except for the following grievances:
- Nushell was bugging the heck out inconsistently for remote sessions (ssh)
- I had to log out and back to have hyprland reload its config
- And the last and finally straw that pushed me to [hjem](https://github.com/feel-co/hjem) was [matugen](https://github.com/InioX/matugen)

It was a pain to integrate matugen seamlessly into this, so I decided to just
switch over the parts of my config that required matugen to use Hjem. I may or
may not soon translate all the wrappers that I am using currently into plain ol
hjem configs but that's for later. 

At its current the hjem + matugen configuration is only able to work with a
single wallpaper therefor it is locked to a single user configuration. I am
sure I can extend it to support multiple users but as of now I don't yet have
the need to do so.

You can look into `users/Wrappers` for the config of each of the programs I
have tinkered with most notably **mpv** featuring support for anime4k shaders
and a custom **neovim** configuration with
[lze](https://github.com/BirdeeHub/lze) lazy loading.

And as of 15th march 2025, newer configs will live in `users/Configs` with their
supporting matugen templates in `nixosModules/external/matugen/templates`

I have also exposed neovim in the flake for the convenience of running it with
```bash
nix run github:Rexcrazy804/Zaphkiel
```

> NOTE: nix running `#nvim-no-lsp` yields the config without downloading any LSPS
the default is `#nvim-wrapped`

#### Credits & Thanks
Firstly I have to thank [sioodmy](https://github.com/sioodmy) for being the
inspiration to ditch home manager and writing wrappers myself I had known of
wrappers before but if it weren't for him I wouldn't have heard of
`pkgs.symlinkJoin` :D

I also extend my gratitude to [notAShelf](https://github.com/NotAShelf) for
being the inspiration for this readme and for developing the hjem nixos
module

I have to thank both the AnAnimeGameLauncher and Hyprland discord communities
for all the help I've received and continue to receive.

Lastly, I have to to thank the nix community for their efforts in
[home-manager](https://github.com/nix-community/home-manager) and
[nixvim](https://github.com/nix-community/nixvim) both of which have been great
resources throughout my early adventure through nix

#### Licensing
All code in this repository is under the MIT license unless wherever an
explicit licensing is included.

#### Wallpaper Sources
- Seraphine: [lingsha by ATDAN-](https://www.pixiv.net/en/artworks/123071255)
- Aphrodite: [kokomi by Shaovie](https://www.pixiv.net/en/artworks/116824847)
