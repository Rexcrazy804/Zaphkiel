# My NixOS Configuration

https://github.com/user-attachments/assets/d11e9823-eb62-470c-9f0d-cb175bb60cbc

- Wallpaper: [The Herta by meirong](https://www.pixiv.net/artworks/126270092)
- [Installation Guide](users/dots/quickshell/kurukurubar/README.md)

## Overview

| Component | Software | Configuration |
| --------- | -------- | ------------- |
|KuruKuruBar|[Quickshell](https://quickshell.outfoxxed.me/)|[`users/dots/quickshell/kurukurubar`](users/dots/quickshell/kurukurubar)|
|Compositor|[Hyprland](https://hyprland.org/)|[`users/dots/hyprland/`](users/dots/hyprland/)|
|Launcher|[Fuzzel](https://codeberg.org/dnkl/fuzzel)|[`users/dots/fuzzel`](users/dots/fuzzel)|
|Colors|[Matugen](https://github.com/InioX/matugen)|[`nixosModules/external/matugen/templates/`](nixosModules/external/matugen/templates/)|
|Terminal|[Foot](https://codeberg.org/dnkl/foot)|[`users/dots/foot/foot.ini`](users/dots/foot/foot.ini)|
|Editor|[Neovim](https://neovim.io/)|[`users/dots/nvim/`](users/dots/nvim/)|
|Wallpapers|[booru-flake](https://github.com/Rexcrazy804/booru-flake)|[`nixosModules/programs/booru-flake/preview.md`](nixosModules/programs/booru-flake/preview.md)|
|Cursor|[Kokomi Cursor](https://www.pling.com/p/2167734/)| nil / really long random text to make this table very wide yes looks like I|

## Nix

- [hjem](https://github.com/feel-co/hjem) + [hjem-impure](https://github.com/Rexcrazy804/hjem-impure) over home manager
- Adorable kurukurubar complimented by the fabulous kurukurulock

### timeline

last revision where Zaphkiel was an npins based config:

> [fc91df912](https://github.com/Rexcrazy804/Zaphkiel/tree/fc91df912fd8811ab33456b1f13a33bbe216b36b)

~~Last revision where Zaphkiel was flake based~~ pre-npins flake config:

> [0eee46d1e](https://github.com/Rexcrazy804/Zaphkiel/tree/0eee46d1e5d98c3b94d39795b73a39270fc61ad7)

### Exported packages

The following packages are exported by this flake:

| package | description |
| ------- | ----------- |
| kurukurubar (stable)| adorable bar to spin the kuru kuru |
| kurukurubar-unstable | latest version, uses master version of qs |
| kokCursor | A cute kokomi XCursor |
| xvim | My neovim configuration using [mnw](https://github.com/Gerg-L/mnw). provides `.default` and `.minimal`|
| mpv | My mpv configuration with [anime4k](https://github.com/bloc97/Anime4K) shaders baked in |
| librebarcode | The [librebarcode](https://graphicore.github.io/librebarcode/) font |

you may run any of the above with the following command (ofc you can't run a
cursor, `nix build` it instead) replacing `nixvim` with your desired package

```bash
nix run github:Rexcrazy804/Zaphkiel#nixvim
```

<details>
<summary><h3>kurkurubar stable or unstable</h3></summary>

<ins>kurkurubar (stable)</ins>

- uses nixpkgs version of quickshell (v0.2.0)
- ~uses [this revision](https://github.com/Rexcrazy804/Zaphkiel/tree/cc6d5cf12ae824e6945cc2599a2650d5fe054ffe) of Zaphkiel dots (last version that is compatible with v0.1.0)~
- ^ currently tracks master branch, not diverged yet
- package updated every major tagged release of quickshell

<ins>kurkurubar-unstable</ins>

- follows Zaphkiel master branch HEAD
- uses untagged master revisions of quickshell
- by default uses my patched version of qs (for finger print unlock in greetd)
- requires quickshell to be built from source

For more information on both see the [internal overlay](pkgs/overlays/internal.nix)

</details>

### Exported modules

Well there is only one module that is exported rn,
and that is *DRUM ROLL* kurukuruDM!!!
now available as `nixosModules.kurukuruDM` :D

> if you run into errors please open an issue,
> since I don't use the flake exported module
> there is a chance for the exported module being broken

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
flake.nix               # sneaky flake.nix that uses npins for inputs
license                 # MIT License
```

## Acknowledgement

Firstly, I have to thank [sioodmy](https://github.com/sioodmy)
for being the inspiration to ditch home manager and writing wrappers myself.
I had known of wrappers before, but if it weren't for him,
I wouldn't have heard of `pkgs.symlinkJoin` :D

I also extend my gratitude to [NotAShelf](https://github.com/NotAShelf)
for developing the hjem nixos module. And also for his welcome criticism
on some of the dumb nix code I've written.

I have to thank both the AnAnimeGameLauncher and Hyprland discord communities
for all the help I've received and continue to receive.

Lastly, I have to thank the nix community for their efforts in
[home-manager](https://github.com/nix-community/home-manager)
and [nixvim](https://github.com/nix-community/nixvim).
Both of which have been great resources throughout my early adventures in nix.

### Quickshell

- [nydragon/nysh](https://github.com/nydragon/nysh)
- [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland/tree/ii-qs/.config/quickshell)
- [pikabar](https://git.pika-os.com/wm-packages/pikabar/src/branch/main/pikabar/usr/share/pikabar)
- [soramanew/rainingkurukuru](https://github.com/soramanew/rainingkuru)
- [outfoxxed/nixnew](https://git.outfoxxed.me/outfoxxed/nixnew/src/branch/master/modules/user/modules/quickshell)
- one unmentioned individual that did not return
- and other homies in `#rice-discussion` of Hyprland discord

## Licensing

All code in this repository is under the MIT license
except wherever an explicit licensing is included.
