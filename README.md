# My NixOS Configuration
![wall](https://github.com/Rexcrazy804/Zaphkiel/blob/master/nixosModules/programs/sddm-wall.png?raw=true)

#### What have you done?
I have killed home manager, and then I've killed nixvim. All in the favour of
wrapping stuff myself, you can lookinot `users/Wrappers` for config for each of
the programs I have tinkered with most notably *mpv* featuring support for
anime4k shadders and a custom *neovim* configuration with
[lze](https://github.com/BirdeeHub/lze) lazy loading.

I have exposed neovim in the flake for the convenience of running it with
```bash
nix run github:Rexcrazy804/Zaphkiel#nvim-lsp-wrapped
```

> NOTE: nix running `nvim-lsp` will download the LSPs but neovim itself won't be able to access the binaries
therefore `nvim-lsp` should only be used when installing the package. Hence please install `nvim-lsp-wrapped`
for running with nix run and just `nvim` if you don't need the LSPs

#### Where is that cute anime girl from?
Its ai generated (using cetusmix whalefal2), so feel free to grab it /
