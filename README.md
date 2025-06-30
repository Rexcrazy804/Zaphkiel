# My NixOS Configuration

https://github.com/user-attachments/assets/d11e9823-eb62-470c-9f0d-cb175bb60cbc

- Wallpaper: [The Herta by meirong](https://www.pixiv.net/artworks/126270092)

## Overview
> The entry point for *most* of the dots are [here](users/dots). For certain
> programs, the colors are injected either directly from matugen or by nix using
> the generated matugen `theme.json`.

> For nix users new to [hjem](https://github.com/feel-co/hjem),
> the entry point for planting my dotfiles in place is [here](users/rexies.nix).

| Component | Software | Configuration |
| --------- | -------- | ------------- | 
|KuruKuruBar|[Quickshell](https://quickshell.outfoxxed.me/)|[`users/dots/quickshell/kurukurubar`](users/dots/quickshell/kurukurubar)|
|Compositor|[Hyprland](https://hyprland.org/)|[`users/dots/hyprland/`](users/dots/hyprland/)|
|Launcher|[Fuzzel](https://codeberg.org/dnkl/fuzzel)|[`users/dots/fuzzel/fuzzel.ini`](users/dots/fuzzel/fuzzel.ini)|
|Colors|[Matugen](https://github.com/InioX/matugen)|[`nixosModules/external/matugen/templates/`](nixosModules/external/matugen/templates/)|
|Terminal|[Foot](https://codeberg.org/dnkl/foot)|[`users/dots/foot/foot.ini`](users/dots/foot/foot.ini)|
|Wallpapers|[booru-flake](https://github.com/Rexcrazy804/booru-flake)|[`nixosModules/programs/booru-flake/preview.md`](nixosModules/programs/booru-flake/preview.md)|
|Cursor|[Kokomi Cursor](https://www.pling.com/p/2167734/)| nil / really long random text to make this table very wide yes looks like I|

## What the heck is going on here?
- npins based non flake nixos configuration
- hjem over home manager
- matugen injecting colors based on wallpaper
- booru flake image collection to neatly access images all over the flake
- exports a flake.nix that relies on npins' nixpkgs source for repo flake support

<details open>
<summary><h3>The long answer</h3></summary>

> if you'd prefer it please see these delightful blogs by Jade <br>
> [Flakes aren't real](https://jade.fyi/blog/flakes-arent-real/) <br>
> [Pinning nixos with npins](https://jade.fyi/blog/pinning-nixos-with-npins/) <br>

My pursuit of faster evaluation times and minimal abstractions started with a
dive into [sioodmy's](https://github.com/sioodmy) nixos configuration. It
showed a whole new world of not relying on home-manager and wrapping programs.

Guess what happens when you stop relying on home-manager abstractions? Your nix
evals go from over 40 seconds to less than 25. Of course this is gonna vary
based on how spec'ed out your system is but on `Aphrodite` I simply was unable
to eval my configuration solely because of home-manager, and later despite
home-manager's removal it still took an absurd duration because of nixvim. That
gave me enough reason to ditch them both.

My initial solution was to completely go down the sioodmy route of wrapping
everything, aaaand you guessed it, That did not go well. These are the few grievances
- Nushell was bugging the heck out inconsistently for remote sessions (ssh)
- I had to log out and back in to have hyprland reload its config
- matugen, I couldn't think of a wrapped solutions with matugen back then

And oh well what do I do? On one hand the above really sucked especially the
thing with hyprland; like I am already waiting 18-25 seconds to rebuild the
darn thing and now I gotta logout and login? F### that!!

> `mkOutOfStoreSymlink` Link Exists for those who are using home-manager and
> don't want to rebuild whole system. However, that doesn't change the fact
> that home-manager is slow.

Let me introduce you to [hjem](https://github.com/feel-co/hjem) a very thin
wrapper around systemd-tmpfiles to pretty much just stash your dots in place,
and hey, that's exactly what I needed and its beautiful.

Now with all that evals were neatly averaging around 20s, but hey that's quite
far away from a dream like <10s eval time. Guess what? Enter
[lix](https://lix.systems/). Basically nix but faster, simply switching to lix
gave me a new average eval time of 15s.

> when I am talking about eval times here, its generally the time it takes for
> a nixos-rebuild test/switch to complete executing after a small change in
> dots or removal of a package.

And now, very recently (June 2025), I've made the decision to move away from
nix flakes. What motivated this is primarily to couple away from the redundant
dependencies of poorly composed flakes and further chip away at the stone of my
ideal eval time (<10s). With jade's two blogs in hand and the accumulated
experience of working with nix for over a year I've pushed onto deflaking with
Sayonara flake #46 and #45. Those pr's whould largely highlight the changes I
had to make and the challenges that I've had to overcome to ensure that
everything works the way it used to before the de-flaking. 

And I've come to love this way of managing my configuration, manually importing
modules and writing my own overlays to minimize the overhead introduced by
bloated flakes of some repos, like seriously some flakes need to embrace KISS.
Ultimately at the end of the day flakes is heavily opinionated, and this
repository is a testament to how I want to consume nixos flakes.
</details>

Lastly, you may want to ask: Rexi, how fast is your eval time?
> `nixos-rebuild dry-build --option eval-cache false` completed in `9.5s`

## Exported packages
The following packages are exported by this flake:

| package | description |
| ------- | ----------- |
| quickshell | My quickshell configuration, specifically kurukurubar |
| kokCursor | A cute kokomi XCursor |
| nixvim | My custom neovim configuration wrapped using the builtin neovim-unstable wrapper|
| nixvim-minimal | less bloated version (no lsps) don't confuse this and above with the [nixvim](https://github.com/nix-community/nixvim) project. |
| mpv | My mpv configuration with [anime4k](https://github.com/bloc97/Anime4K) shaders baked in |

you may run any of the above with the following command (ofc you can't run a
cursor, `nix build` it instead) replacing `nixvim` with your desired package
```bash
nix run github:Rexcrazy804/Zaphkiel#nixvim
```

## Flake Structure
```
hosts/                  # starting point for host specific configuration
- <hostname>/           # divided into three files for seperation
- - extras/             # things I am lazy to seperate into a module just yet

nixosModules/           # common options and defaults shared across all hosts
- external/             # used for hosting modified nixos modules that aren't written by me
- graphics/             # novideo and friends
- nix/                  # my beloved
- programs/             # options wraping other nixos options for programs
- - booru-flake/        # fuck around and find out
- - hyprland/           # scripts and nix related hyprland config
- server/               # same as above but for services
- - minecraft/          # nix-minecrat entry point
- system/               # largely defaults
- - networking/         # networking setup with dnscrypt-proxy2
- server-default.nix    # strictly imports server only stuff

npins/                  # flakes? what is that?
- default.nix           # auto generated file to import npins
- sources.json          # where is the flake.lock? here it is `sources.json`

pkgs/                   # exported packages are found here
- overlays/             # overlays (duh)

secrets/                # home to my age encrypted secrets
templates/              # reusable flake and non flake templates for various nix errands

users/                  # user specific configuration imported by hosts hosting said user
- dots/                 # ricers, this is the .config/ folder you might be looking for
- - <program>/          # doots
- - hyprland/           # might niri, too lazy for now, hyprland
- - quickshell/         # god bless foxxed for creating this lovely thing
- - - kurukurubar/      # adorable bar for kuru kuru maxxing
- - - kurumibar/        # my first now unmainted rectangle bar
- rexies.nix            # main file responsible for leveraging hjem to plant dots in place
- <others>.nix          # other users

README.md               # are you reading me yet?
default.nix             # main file that is evaluated to build the nixos configuration
flake.nix               # sneaky flake.nix that uses npins for inputs
license                 # MIT License
rebuild.sh              # evaluates npins and calls default.nix to rebuild
```

## Acknowledgement
Firstly, I have to thank [sioodmy](https://github.com/sioodmy) for being the
inspiration to ditch home manager and writing wrappers myself. I had known of
wrappers before, but if it weren't for him, I wouldn't have heard of
`pkgs.symlinkJoin` :D

I also extend my gratitude to [NotAShelf](https://github.com/NotAShelf) for
being the inspiration for this readme and for developing the hjem nixos
module.

I have to thank both the AnAnimeGameLauncher and Hyprland discord communities
for all the help I've received and continue to receive.

Lastly, I have to thank the nix community for their efforts in
[home-manager](https://github.com/nix-community/home-manager) and
[nixvim](https://github.com/nix-community/nixvim). Both of which have been
great resources throughout my early adventures in nix.

### Quickshell
- [nydragon/nysh](https://github.com/nydragon/nysh)
- [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland/tree/ii-qs/.config/quickshell)
- [pikabar](https://git.pika-os.com/wm-packages/pikabar/src/branch/main/pikabar/usr/share/pikabar)
- [soramanew/rainingkurukuru](https://github.com/soramanew/rainingkuru)
- [outfoxxed/nixnew](https://git.outfoxxed.me/outfoxxed/nixnew/src/branch/master/modules/user/modules/quickshell)
- one unmentioned individual that did not return
- and other homies in `#rice-discussion` of Hyprland discord

## Licensing
All code in this repository is under the MIT license unless wherever an
explicit licensing is included.
