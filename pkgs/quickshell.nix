{
  rev,
  quickshell,
}:
# only override the drv with my patch if its the latest rev from my fork
if rev == "ab6c42d1b8369614c767c138eca175d75622988c"
then
  quickshell.override {
    quickshell-unwrapped =
      (quickshell.unwrapped.override {
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
else quickshell
