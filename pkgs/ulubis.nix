# this does not quite work
# well it somewhat does but ultimately shoots itself due to opengl error
# you can't quite launch it inside an other wayland compositor
# but whatever, I wanted to learn a bit more of lisp packaging
# and this is how far I've gotten.
#
# is library versioning not a thing in lisp?
# or are these libraries working just fine cause they haven't
# been updated in since the dinosaurs went extinct?
# Ah well, I'll know eventually
#
# Your truly,
# Rexiel Scarlet <3
{
  sbclPackages,
  sbcl,
  fetchFromGitHub,
  libxkbcommon,
  wayland,
  writeText,
  makeWrapper,
  libgbm,
  libdrm,
  libGL,
  libinput,
}: let
  ulubis-drm-gbm = fetchFromGitHub {
    owner = "malcolmstill";
    repo = "ulubis-drm-gbm";
    rev = "9cd5bcdd8b0507dec67f5d17dc87ab5c64a4dbd2";
    hash = "sha256-fsk+Pa4SB4xbsYvsL4olyWDFsAoYbnQlVUyVjkZ6Xh0=";
  };
in
  sbcl.buildASDFSystem {
    pname = "ulubis";
    version = "unstable";

    src = fetchFromGitHub {
      owner = "malcolmstill";
      repo = "ulubis";
      rev = "23c89ccd5589930e66025487c31531f49218bb76";
      hash = "sha256-zQj5Ml+2d3DTNa9uH2al/xutBmBTrXkR5EE/Kbf1fbs=";
    };

    postPatch = ''
      substituteInPlace install.lisp \
        --replace-warn "(ql:where-is-system :ulubis)" '(sb-unix::posix-getenv "out")'
      cp -R ${ulubis-drm-gbm}/* ./ulubis-drm-gbm/
    '';

    systems = ["ulubis"];

    nativeLibs = [
      libxkbcommon
      makeWrapper
    ];

    lispLibs = let
      sbclPackages' = sbclPackages.overrideScope (final: prev: {
        # indirect dependencies
        cl-gbm = prev.cl-gbm.overrideLispAttrs (_oldAttrs: {
          nativeLibs = [libgbm final.cepl];
          postPatch = ''
            substituteInPlace cl-gbm.lisp \
            --replace-warn '/usr/lib/x86_64-linux-gnu/libgbm.so.1' '${libgbm}/lib/libgbm.so'
          '';
        });
        cl-drm = prev.cl-drm.overrideLispAttrs (_oldAttrs: {
          nativeLibs = [libdrm final.cepl];
          postPatch = ''
            substituteInPlace cl-drm.lisp \
            --replace-warn '/usr/lib/x86_64-linux-gnu/libdrm.so.1' '${libdrm}/lib/libdrm.so'
          '';
        });
        cl-egl = prev.cl-egl.overrideLispAttrs (_oldAttrs: {
          nativeLibs = [libGL final.cepl];
          postPatch = ''
            substituteInPlace cl-egl.lisp \
            --replace-warn '/usr/lib/x86_64-linux-gnu/libegl.so.1' '${libGL}/lib/libegl.so'
          '';
        });
      });
    in
      with sbclPackages'; [
        cffi
        osicat
        swank
        cepl
        rtg-math
        rtg-math_dot_vari
        easing
        trivial-dump-core
        trivial-backtrace
        cl-cairo2
        zpng
        (cepl_dot_drm-gbm.overrideLispAttrs (_oldAttrs: {
          postPatch = ''
            substituteInPlace cepl.drm-gbm.lisp \
              --replace-warn "/dev/dri/card0" "/dev/dri/card1" # WHY THE FUCK?
          '';
        }))
        (cl-libinput.overrideLispAttrs (_oldAttrs: {nativeLibs = [libinput];}))
        (cl-wayland.overrideLispAttrs (_oldAttrs: {nativeLibs = [wayland];}))
        (cl-xkb.overrideLispAttrs (_oldAttrs: {
          src = fetchFromGitHub {
            owner = "malcolmstill";
            repo = "cl-xkb";
            rev = "9d4a74a7c2bd30490dd83b926f1362c6855d02e4";
            hash = "sha256-JJkKFk9RIXpCIIqx46GlnCpA7kz6Ia2ttg/IBoO+ywg=";
          };
          postPatch = ''
            # for whatever fucking reason it fails despite doing the right thing?
            # either skill issue on my end or I am too tired to figure out whats going wrong
            # atleast it fucking works for now
            substituteInPlace cl-xkb.lisp \
              --replace-warn '/usr/lib64/libxkbcommon.so' '${libxkbcommon}/lib/libxkbcommon.so'
          '';
        }))
      ];

    buildScript =
      writeText "build-ulubis.lisp"
      /*
      lisp
      */
      ''
        (defpackage :nix-cl-user (:use :cl))
        (in-package :nix-cl-user)

        ;; Load ASDF
        (load (concatenate 'string (sb-ext:posix-getenv "asdfFasl") "/asdf.fasl"))
        (asdf:initialize-output-translations '(:output-translations :disable-cache :inherit-configuration))
        (mapcar #'asdf:load-system (uiop:split-string (uiop:getenv "systems")))

        ;; this fails presently cause its a circular dependency? fml
        (load "ulubis-drm-gbm/ulubis-drm-gbm.asd")
        (asdf:load-system :ulubis-drm-gbm)

        (trivial-dump-core:save-executable "ulubis" #'ulubis::run-compositor)
        (exit)
      '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -Dm777 ulubis $out/bin

      wrapProgram $out/bin/ulubis \
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH"
      # --prefix DYLD_LIBRARY_PATH : "$DYLD_LIBRARY_PATH"

      runHook postInstall
    '';
  }
