# My NixOS Configuration

https://github.com/user-attachments/assets/d11e9823-eb62-470c-9f0d-cb175bb60cbc

- Wallpaper: [The Herta by meirong][wallpaper]
- [Installation Guide][install guide]

## Summary

| Component | Software | Configuration |
| --------- | -------- | ------------- |
|KuruKuruBar|[Quickshell]|[`dots/quickshell/kurukurubar`][kurudots]|
|Compositor|[MangoWC]|[`dots/mango`][mangodots]|
|Launcher|[Fuzzel]|[`dots/fuzzel`][fuzldots]|
|Colors|[Matugen]|[`nixosModules/external/matugen/templates/`][mtgndots]|
|Terminal|[foot]|[`dots/foot/foot.ini`][footdots]|
|Editor|[Neovim]|[`dots/nvim/`][nvimdots]|
|Wallpapers|[booru-hs]|[`dots/booru/preview.md`][booru images]|
|Cursor|[Kokomi Cursor][kokcursor]| nil / really long random text to make this table very wide yes looks like I|

- [hjem] + [hjem-impure] over home manager
- last revision where Zaphkiel was a normal flake
  [1164182e][pre-dandelion-rev]
- last revision where Zaphkiel was an npins based config
  [fc91df912][npins-rev]
- ~~Last revision where Zaphkiel was flake based~~ pre-npins flake config
  [0eee46d1e][flake-rev]

## What in the nix is going on here?

The flake implements the [dandruff pattern], without flake-parts.
Should you try it? Well, perhaps you can?
There is ZERO documentation about this besides my own configuration,
HOWEVER, this is fairly trivial.

I simply have two functions.
The first accepts a path and generates a list of paths to nix files.
The second accepts a list of either:

1. a nix expression that is an attribute set or a function that returns an attribute set
1. a path to a .nix file containing (1.)

Each entry is first converted into an attribute set if not already (by calling the function)
and then merged using `recursiveUpdate`.

I was initially against recommending this since I ran into the problem of merging functions,
deciding thus to hold off from recommending it till I've explored it further.
But thus far, function merging remains as the sole problem,
which can be easily avoided by not having duplicated namespaces.

Some interesting files to take a look at would be:

- [nixosConfiguration.nix](modules/nixosConfigurations.nix) Automatic creation of hosts as long as a dandelion.hosts.<hostname> is defined.
- [packages.nix](modules/packages.nix) + [packages-extra.nix](modules/packages-extra.nix) Showcases recursive merging

## Acknowledgement

Firstly, I have to thank [sioodmy]
for being the inspiration to ditch home manager and writing wrappers myself.
I had known of wrappers before, but if it weren't for him,
I wouldn't have heard of `pkgs.symlinkJoin` :D

I also extend my gratitude to [NotAShelf]
for developing the hjem nixos module. And also for his welcome criticism
on some of the dumb nix code I've written.

After two months of being on a normal, sane, nixos configuration,
I have switched to the dandelion pattern (no I won't be spelling it correctly)
largely due to [argosnothing] shilling [jet]'s nixos configuration a great deal.

### Quickshell

- [nydragon/nysh][nysh]
- [end-4/dots-hyprland][enddots]
- [pikabar]
- [soramanew/rainingkurukuru][rainingkuru]
- [outfoxxed/nixnew][nixnew]
- one unmentioned individual that did not return
- and other homies in `#rice-discussion` of Hyprland discord

## Licensing

All code in this repository is under the MIT license
except wherever an explicit licensing is included.

[argosnothing]: https://github.com/argosnothing
[booru images]: dots/booru/preview.md
[booru-hs]: https://github.com/Rexcrazy804/booru.hs
[dandruff pattern]: https://github.com/Michael-C-Buckley/nixos/blob/cfb8cfa3ee815cbb216cc3b9361373be4837a126/documentation/intent.md#dendritic-nix
[enddots]: https://github.com/end-4/dots-hyprland/tree/ii-qs/.config/quickshell
[flake-rev]: https://github.com/Rexcrazy804/Zaphkiel/tree/0eee46d1e5d98c3b94d39795b73a39270fc61ad7
[foot]: https://codeberg.org/dnkl/foot
[footdots]: dots/foot/foot.ini
[fuzldots]: dots/fuzzel
[fuzzel]: https://codeberg.org/dnkl/fuzzel
[hjem]: https://github.com/feel-co/hjem
[hjem-impure]: https://github.com/Rexcrazy804/hjem-impure
[install guide]: dots/quickshell/kurukurubar/README.md
[jet]: https://github.com/Michael-C-Buckley
[kokcursor]: https://www.pling.com/p/2167734/
[kurudots]: dots/quickshell/kurukurubar
[mangodots]: dots/mango/
[mangowc]: https://github.com/DreamMaoMao/mangowc
[matugen]: https://github.com/InioX/matugen
[mtgndots]: dots/matugen/templates/
[neovim]: https://neovim.io/
[nixnew]: https://git.outfoxxed.me/outfoxxed/nixnew/src/branch/master/modules/user/modules/quickshell
[notashelf]: https://github.com/NotAShelf
[npins-rev]: https://github.com/Rexcrazy804/Zaphkiel/tree/fc91df912fd8811ab33456b1f13a33bbe216b36b
[nvimdots]: dots/nvim/
[nysh]: https://github.com/nydragon/nysh
[pikabar]: https://git.pika-os.com/wm-packages/pikabar/src/branch/main/pikabar/usr/share/pikabar
[pre-dandelion-rev]: https://github.com/Rexcrazy804/Zaphkiel/tree/1164182e9abc5dccdd9945e9367ee5eba38b31cb
[quickshell]: https://quickshell.outfoxxed.me/
[rainingkuru]: https://github.com/soramanew/rainingkuru
[sioodmy]: https://github.com/sioodmy
[wallpaper]: https://www.pixiv.net/artworks/126270092
