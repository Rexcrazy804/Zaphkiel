# Kuru Kuru Speen Speen Bar
![image](https://github.com/user-attachments/assets/696bb338-3037-47a0-8415-f67b8fdec103)
- Wallpaper source: [The Herta by meirong](https://www.pixiv.net/artworks/126270092)

A compat and adorable bar designed with the goal of speeening the kuru kuru.
Designed in acordance to google's material 3 guidelines, you can generate
colors from your wallpaper using [matugen](https://github.com/InioX/matugen)
using [this template](../../../../nixosModules/external/matugen/templates/quickshell-colors.qml)
> Note: if you'd like to reserve space for the top bar see the comment in [shell.qml](shell.qml)

## Acknowledgement
- AlbumCover svg by [Squirrel Modeller](https://github.com/SquirrelModeller)
- Particle System ~~stolen from~~ inspired by [soramanew/rainingkuru](https://github.com/soramanew/rainingkuru)

## Many thanks to these homies :>
end_4, sora, a certain individual that has not yet returned, foxxed, starch,
aureus, caesus, oyudays, lysec and squirrel modeller

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
- | PopupPane
- - | PopupNotification
- | InboxPane
- - | Notification
```

> with <3 by Rexiel Scarlet
