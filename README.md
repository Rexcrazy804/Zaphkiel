# My NixOS Configuration

https://github.com/user-attachments/assets/d11e9823-eb62-470c-9f0d-cb175bb60cbc

- Wallpaper: [The Herta by meirong][wallpaper]
- [Installation Guide][install guide]

## Overview

| Component | Software | Configuration |
| --------- | -------- | ------------- |
|KuruKuruBar|[Quickshell]|[`users/dots/quickshell/kurukurubar`][kurudots]|
|Compositor|[Hyprland]|[`users/dots/hyprland/`][hyprdots]|
|Launcher|[Fuzzel]|[`users/dots/fuzzel`][fuzldots]|
|Colors|[Matugen]|[`nixosModules/external/matugen/templates/`][mtgndots]|
|Terminal|[foot]|[`users/dots/foot/foot.ini`][footdots]|
|Editor|[Neovim]|[`users/dots/nvim/`][nvimdots]|
|Wallpapers|[booru-hs]|[`nixosModules/programs/booru-flake/preview.md`][booru images]|
|Cursor|[Kokomi Cursor][kokcursor]| nil / really long random text to make this table very wide yes looks like I|

- [hjem] + [hjem-impure] over home manager
- last revision where Zaphkiel was an npins based config
  [fc91df912][npins-rev]
- ~~Last revision where Zaphkiel was flake based~~ pre-npins flake config
  [0eee46d1e][flake-rev]

## Exported packages

The following packages are exported by this flake:

| package | description |
| ------- | ----------- |
| kurukurubar (stable)| adorable bar to spin the kuru kuru |
| kurukurubar-unstable | latest version, uses master version of qs |
| kokCursor | A cute kokomi XCursor |
| xvim | My neovim configuration using [mnw] provides `.default` and `.minimal`|
| mpv | My mpv configuration with [anime4k] shaders baked in |
| librebarcode | The [librebarcode] font |

you may run any of the above with the following command (ofc you can't run a
cursor, `nix build` it instead) replacing `nixvim` with your desired package

```bash
nix run github:Rexcrazy804/Zaphkiel#nixvim
```

<details>
<summary><h3>kurkurubar stable or unstable</h3></summary>

<ins>kurkurubar (stable)</ins>

- uses nixpkgs version of quickshell (v0.2.0)
- currently tracks master branch, not diverged yet
- package updated every major tagged release of quickshell

<ins>kurkurubar-unstable</ins>

- follows Zaphkiel master branch HEAD
- uses untagged master revisions of quickshell
- by default uses my patched version of qs (for finger print unlock in greetd)
- requires quickshell to be built from source

For more information on both see the [pkgs/default.nix](pkgs/default.nix)

</details>

## Exported modules

Well there is only one module that is exported rn,
and that is *DRUM ROLL* kurukuruDM!!!
now available as `nixosModules.kurukuruDM` :D

## Structure overview

```
hosts/                  # starting point for host specific configuration
- <hostname>/           # divided into three files for seperation
- - extras/             # things I am lazy to seperate into a module just yet

nixosModules/           # common options and defaults shared across all hosts
- exported/             # modules exported by toplevel default.nix (and flake.nix)
- external/             # used for hosting modified nixos modules that aren't written by me
- graphics/             # novideo and friends
- nix/                  # my beloved
- programs/             # options wraping other nixos options for programs
- server/               # same as above but for services
- system/               # largely defaults
- - networking/         # networking setup with dnscrypt-proxy2

npins/                  # npins for pinning non flake stuff

pkgs/                   # exported packages are found here
- anime-launchers       # crane enabled builds for aagl launchers family
- lanzaboote            # derivation to build lanzaboote without flakes
- mpv/                  # mpv wrapper with anime4k
- overlays/             # overlays (duh)
- scripts/              # cute scripts to do various things

secrets/                # home to my age encrypted secrets
templates/              # reusable flake and non flake templates for various nix errands

users/                  # user specific configuration imported by hosts hosting said user
- dots/                 # ricers, this is the .config/ folder you might be looking for
- - <program>/          # doots
- - hyprland/           # might niri, too lazy for now, hyprland
- - nvim/               # nvim configuration
- - quickshell/         # god bless foxxed for creating this lovely thing
- - - kurukurubar/      # adorable bar for kuru kuru maxxing
- - - kurumibar/        # my first now unmainted rectangle bar
- - - shell.nix         # devshell for qml development with quickshell
- rexies.nix            # my user, leverages hjem the most
- <others>.nix          # other users

README.md               # are you reading me yet?
flake.nix               # flakes this flake that, how about you flake-
license                 # MIT License
```

## Acknowledgement

Firstly, I have to thank [sioodmy]
for being the inspiration to ditch home manager and writing wrappers myself.
I had known of wrappers before, but if it weren't for him,
I wouldn't have heard of `pkgs.symlinkJoin` :D

I also extend my gratitude to [NotAShelf]
for developing the hjem nixos module. And also for his welcome criticism
on some of the dumb nix code I've written.

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

[anime4k]: https://github.com/bloc97/Anime4K
[booru images]: nixosModules/programs/booru-flake/preview.md
[booru-hs]: https://github.com/Rexcrazy804/booru.hs
[enddots]: https://github.com/end-4/dots-hyprland/tree/ii-qs/.config/quickshell
[flake-rev]: https://github.com/Rexcrazy804/Zaphkiel/tree/0eee46d1e5d98c3b94d39795b73a39270fc61ad7
[foot]: https://codeberg.org/dnkl/foot
[footdots]: users/dots/foot/foot.ini
[fuzldots]: users/dots/fuzzel
[fuzzel]: https://codeberg.org/dnkl/fuzzel
[hjem]: https://github.com/feel-co/hjem
[hjem-impure]: https://github.com/Rexcrazy804/hjem-impure
[hyprdots]: users/dots/hyprland/
[hyprland]: https://hyprland.org/
[install guide]: users/dots/quickshell/kurukurubar/README.md
[kokcursor]: https://www.pling.com/p/2167734/
[kurudots]: users/dots/quickshell/kurukurubar
[librebarcode]: https://graphicore.github.io/librebarcode/
[matugen]: https://github.com/InioX/matugen
[mnw]: https://github.com/Gerg-L/mnw
[mtgndots]: users/dots/matugen/templates/
[neovim]: https://neovim.io/
[nixnew]: https://git.outfoxxed.me/outfoxxed/nixnew/src/branch/master/modules/user/modules/quickshell
[notashelf]: https://github.com/NotAShelf
[npins-rev]: https://github.com/Rexcrazy804/Zaphkiel/tree/fc91df912fd8811ab33456b1f13a33bbe216b36b
[nvimdots]: users/dots/nvim/
[nysh]: https://github.com/nydragon/nysh
[pikabar]: https://git.pika-os.com/wm-packages/pikabar/src/branch/main/pikabar/usr/share/pikabar
[quickshell]: https://quickshell.outfoxxed.me/
[rainingkuru]: https://github.com/soramanew/rainingkuru
[sioodmy]: https://github.com/sioodmy
[wallpaper]: https://www.pixiv.net/artworks/126270092
