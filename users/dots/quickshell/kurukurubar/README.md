# Kuru Kuru Bar

![image](https://github.com/user-attachments/assets/caec808f-7945-466f-807e-765d69804c76)

- Wallpaper source: [The Herta by meirong](https://www.pixiv.net/artworks/126270092)

A compat and adorable bar designed with the goal of speeening the kuru kuru.
Designed in acordance to google's material 3 guidelines.
You may generate colors from your wallpaper using [matugen](https://github.com/InioX/matugen)
with [this template](../../../../nixosModules/external/matugen/templates/quickshell-colors.qml)

| [Kokomi by omochichi96](https://twitter.com/omochichi96/status/1758113643521245240) | [Shinobu by solipsist](https://www.pixiv.net/en/artworks/119108248) |
|----------|----------|
|![image](https://github.com/user-attachments/assets/7ed235f1-0a49-4546-be01-16197dc7940f) | ![image](https://github.com/user-attachments/assets/16cb7c57-92b2-4178-a5e6-d9023012f473) |

### Depencencies

- quickshell
- material-symbols
- nerdfonts
- [librebarcode](https://graphicore.github.io/librebarcode/) (should be available in the google-fonts package)
- qtmultimedia (prolly already installed on your system)
- powerprofilesdaemon (optional)
- brightnessctl (optional)
- rembg (required for foreground layer effect)

### Installation

> Beloved nixos cuties, please refer to the
> [Nixos Section](#Nixos)

1. Install the above dependencies using your favourite package manager
1. git clone this repo
1. copy `kurukurubar` folder into `~/.config/quickshell`
1. spawn the bar by running `quickshell`
1. VERY IMPORTANT, press hold the spinning herta to spin her faster - the council of kurukuru

> make sure you are not creating `.config/quickshell/kurukurubar`,
> in which case you will need to pass the arg `-c kurukurubar` in step 4.

### Lock Screen and Foreground Isolation

The lock screen requires a wallpaper to be set
either at the default location `~/.config/background`
or by manually specifying the path with:
(prefer absolute paths '/' or paths starting from your home directory '~/')

```sh
quickshell ipc call config setWallpaper ~/Path/to/your/wallpaper
```

Once the wallpaper is set correctly you may launch the lock screen like so

```sh
quickshell ipc call lockscreen lock
```

The `Fg Layer Extraction` option must be turned on in the Kuru Settings tab
to enable the Foreground isolation effect.
**First run will take time** as rembg downloads the required birefnet model
and processes your wallpaper.
Subsequent runs will depend on your hardware
but the results are cached
so switching to already processed images are instant.

> users of the kurukurubar via nixos flake should replace `quickshell`
> with `kurukurubar` for the commands listed above

### NixOS

This rice is exposed as a package in the toplevel flake
and can be used to run the rice as follows

```
nix run github:Rexcrazy804/Zaphkiel#kurukurubar
```

#### Usage as flake

First add zaphkiel as a flake input

```nix
{
    description = "your cute flake";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        zaphkiel = {
            url = "github:Rexcrazy804/Zaphkiel";
            inputs.nixpkgs.follows = "nixpkgs";
            # optional
            # inputs.quickshell.follows = "quickshell";
            # inputs.systems.follows = "systems";
        };
        # other inputs ...
    };
    outputs = {self, nixpkgs, ...}@inputs: {
        # your outputs ...
    };
}
```

Now you may refer to the kurukurubar package as `inputs.zaphkiel.packages.${pkgs.system}.kurukurubar`

```nix
{
    inputs,
    pkgs,
    ...
}: {
    environment.systemPacakges = [
        inputs.zaphkiel.packages.${pkgs.system}.kurukurubar
        # or alternatively
        inputs.zaphkiel.packages.${pkgs.system}.kurukurubar-unstable
    ];

    # NOTE
    # for running the bar, use `kurukurubar`
    # for instance in the hyprland config, use:
    # exec-once = kurukurubar
}
```

For kurukuruDM you may import and leverage the kurukuruDM module as follows

```nix
{
    inputs,
    pkgs,
    ...
}: {
    imports = [inputs.zaphkiel.nixosModules.kurukuruDM];

    # for more information check the module in 
    # `nixosModules/exported/kurukuruDM.nix`
    programs.kurukuruDM = {
        enable = true;
        package = pkgs.kurukurubar;                     # defaults to kurukurubar-unstable (TODO CHANGE THIS)
        settings = {
            wallpaper = ./path/to/wallpaper;            # you may use fetchurl to get remote images
            instantAuth = false;                        # auto starts authentication, good for fingerprint support ONLY
            default_user = "rexies";                    # set to null for possible values, only usefull for multi user systems
            default_session = "sway";                   # same as above, only usefull for multi session systems
            extraConfig = ''                            # extra configuration passed to underlying hyprland session
              monitor = eDP-1, preferred, auto, 1.25    # you may enter any valid hyprland config here
            '';
        };
    };
}
```

For a complete functional configuration using this flake see
[zaphkieltest](https://github.com/Rexcrazy804/zaphkieltest)

> If your nixpkgs version of quickshell is not v0.2.0,
> kurukurubar (stable) WILL NOT WORK.
> Prefer using kurukurubar-unstable instead

### Known Issues

- `org.Hyprland.style is not installed`: see [#21](https://github.com/Rexcrazy804/Zaphkiel/issues/21#issuecomment-2906546939)
- Herta faceIcon: symlink an image (of any image type) to ~/.face.icon

## Acknowledgement

- AlbumCover svg by [Squirrel Modeller](https://github.com/SquirrelModeller)
- Particle System ~~stolen from~~ inspired by [soramanew/rainingkuru](https://github.com/soramanew/rainingkuru)

## Many thanks to these homies :>

end_4, sora, a certain individual that has not yet returned, foxxed, starch,
aureus, caesus, oyudays, lysec, friday and squirrel modeller

## Components outline

> WARNING <br>
> outdated, will need to redo this later

```
| Notch
- | TopBar
- - | WorkspacePill
- - | MprisDot
- - | TimePill
- - | BrightnessDot
- - | AudioSwiper
- - | BatteryPill
- | ExpanededPane
- - | CentralPane
- - - | HomeView
- - - - | GreeterWidget
- - - - | TrayItemMenu (exported from TrayItem)
- - - - | TrayItem
- - - | CalenderView
- - - | SystemView
- - - - | SessionDots
- - - | MusicView
- - - - | MprisItem
- - - | SettingsView
- - - - | PowerTab
- - - - - | PowerInfo
- - - - | AudioTab
- - - - - | AudioSlider
- - | KuruKuru
- - - | KuruParticleSystem
- - - | NotifDots
- | PopupPane
- - | PopupNotification
- | InboxPane
- - | Notification
```

> with \<3 by Rexiel Scarlet
