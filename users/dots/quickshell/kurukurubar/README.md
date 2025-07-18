# Kuru Kuru Bar
![image](https://github.com/user-attachments/assets/caec808f-7945-466f-807e-765d69804c76)
- Wallpaper source: [The Herta by meirong](https://www.pixiv.net/artworks/126270092)

A compat and adorable bar designed with the goal of speeening the kuru kuru.
Designed in acordance to google's material 3 guidelines, you can generate
colors from your wallpaper using [matugen](https://github.com/InioX/matugen)
using [this template](../../../../nixosModules/external/matugen/templates/quickshell-colors.qml)

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
1. Install the above dependencies using your favourite package manager
2. git clone this repo
3. copy `kurukurubar` folder into `~/.config/quickshell`
4. spawn the bar by running `quickshell`
5. VERY IMPORTANT, press hold the spinning herta to spin her faster - the council of kurukuru

> make sure you are not creating `.config/quickshell/kurukurubar`, in which
> case you will need to pass the arg `-c kurukurubar` in step 4.

### Live running on nix
This rice is exposed as a package in the toplevel flake and can be used to run the rice as follows
```
nix run github:Rexcrazy804/Zaphkiel#kurukurubar
```

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

> with <3 by Rexiel Scarlet
