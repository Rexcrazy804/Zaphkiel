# adapted from
# https://github.com/DreamMaoMao/mangowc/blob/main/nix/default.nix
{
  fetchpatch,
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
  enableXWayland ? true,
  meson,
  ninja,
  scenefx,
  wlroots_0_19,
  libGL,
}:
stdenv.mkDerivation {
  pname = "mango-unwrapped";
  version =
    if (sources.mangowc ? version)
    then sources.mangowc.version
    else "nightly";

  src = sources.mangowc;

  patches = [
    (fetchpatch {
      name = "transparent-wlr-session-lock.patch";
      url = "https://github.com/DreamMaoMao/mangowc/commit/66bf6d5cff790e5209c6850ade5eba9c551d7387.patch";
      hash = "sha256-8WQkAU4t0Ko0/SXgIWIEJu7DrhyVMjf4aqJo9AjfJUk=";
    })
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
