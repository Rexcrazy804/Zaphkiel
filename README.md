# My NixOS Configuration
![wall](https://github.com/Rexcrazy804/Zaphkiel/blob/master/nixosModules/programs/sddm-wall.png?raw=true)

#### What have you done?
TODO explain the switch to hjem
I have killed home manager, and then I've killed nixvim. ~All in the favour of
wrapping stuff myself~, you can look into `users/Wrappers` for the config of each of
the programs I have tinkered with most notably **mpv** featuring support for
anime4k shadders and a custom **neovim** configuration with
[lze](https://github.com/BirdeeHub/lze) lazy loading.

I have exposed neovim in the flake for the convenience of running it with
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
being the inspiration for this readme

I have the thank both the AnAnimeGameLauncher and Hyprland discord communities
for all the help I've received and continue to receive.

Lastly, I have to to thank the nix community for their efforts in
[home-manager](https://github.com/nix-community/home-manager) and
[nixvim](https://github.com/nix-community/nixvim) both of which have been great
resources throughout my early adventure through nix

#### Licensing
All code in this repository is under the MIT license unless wherever
an explicit licensing is included.

#### Wallpaper Sources
- Seraphine + Aphrodite: [kokomi by Shaovie](https://www.pixiv.net/en/artworks/116824847)
