# adapted from
# https://github.com/DreamMaoMao/mangowc/blob/main/nix/default.nix
{
  sources,
  lib,
  libX11,
  libinput,
  libxcb,
  libxkbcommon,
  pcre2,
  pixman,
  pkg-config,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xcbutilwm,
  xwayland,
  meson,
  ninja,
  scenefx,
  wlroots_0_19,
  libGL,
  enableXWayland ? true,
  debug ? false,
}:
stdenv.mkDerivation {
  pname = "mango-unwrapped";
  version =
    if (sources.mangowc ? version)
    then sources.mangowc.version
    else "nightly";

  src = sources.mangowc;

  # patches = [
  #   (fetchpatch {
  #     # fixes hot reloading crashes with animated xcursors
  #     name = "fix-animated-cursor-hot-reload";
  #     url = "https://github.com/DreamMaoMao/mangowc/commit/0f861e79a0d5a53a4a0df3b6226bd1d5452ca37b.patch";
  #     hash = "sha256-r7KPgMc/XxfNKHDgNca1O0BCZleBFmA6I8y6fiLxipY=";
  #   })
  # ];

  mesonFlags = with lib; [
    (mesonEnable "xwayland" enableXWayland)
    (mesonBool "asan" debug)
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs =
    [
      libinput
      libxcb
      libxkbcommon
      pcre2
      pixman
      wayland
      wayland-protocols
      wlroots_0_19
      scenefx
      libGL
    ]
    ++ lib.optionals enableXWayland [
      libX11
      xcbutilwm
      xwayland
    ];

  passthru = {
    providedSessions = ["mango"];
    uwsm-plugin = ./mango-plugin.sh;
  };

  meta = {
    mainProgram = "mango";
    description = "A streamlined but feature-rich Wayland compositor";
    homepage = "https://github.com/DreamMaoMao/mango";
    license = lib.licenses.gpl3Plus;
    maintainers = [];
    platforms = lib.platforms.unix;
  };
}
