{
  quickshell,
  quickshell-unwrapped,
}:
quickshell.override {
  quickshell-unwrapped =
    (quickshell-unwrapped.override {
      withJemalloc = true;
      withQtSvg = true;
      withWayland = true;
      withX11 = false;
      withPipewire = true;
      withPam = true;
      withHyprland = true;
      withI3 = false;
    }).overrideAttrs {
      postPatch = ''
        # required for finger print support
        # temp measure till foxxed fixes it
        substituteInPlace src/services/greetd/connection.cpp \
            --replace-fail "	if (!this->mResponseRequired) {" "	if (false) {"
      '';
    };
}
