# Kuru Kuru Bar
![image](https://github.com/user-attachments/assets/caec808f-7945-466f-807e-765d69804c76)
- Wallpaper source: [The Herta by meirong](https://www.pixiv.net/artworks/126270092)

A compat and adorable bar designed with the goal of speeening the kuru kuru.
Designed in acordance to google's material 3 guidelines, you can generate
colors from your wallpaper using [matugen](https://github.com/InioX/matugen)
using [this template](../../../../nixosModules/external/matugen/templates/quickshell-colors.qml)

### Depencencies
- quickshell
- material-symbols
- nerdfonts
- qtmultimedia (prolly already installed on your system)
- powerprofilesdaemon (optional)
- brightnessctl (optional)

### Known Issues
- `org.Hyprland.style is not installed`: see [#21](https://github.com/Rexcrazy804/Zaphkiel/issues/21#issuecomment-2906546939)
- empty networktab: currently unimplemented waiting for qs to provide a service. For the time being you can use `nm-applet`
- empty face icon in greeter: symlink an image (of any image type) to ~/.face.icon

### Live running on nix
This rice is exposed as a package in the toplevel flake and can be used to run the rice as follows
```
nix run gitub:Rexcrazy804/Zaphkiel#quickshell
```
> Don't panic if its building `quickshell`, no binary cache for that yet

## Acknowledgement
- AlbumCover svg by [Squirrel Modeller](https://github.com/SquirrelModeller)
- Particle System ~~stolen from~~ inspired by [soramanew/rainingkuru](https://github.com/soramanew/rainingkuru)

## Many thanks to these homies :>
end_4, sora, a certain individual that has not yet returned, foxxed, starch,
aureus, caesus, oyudays, lysec, friday and squirrel modeller

## Components outline
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
