# this project is quite sloppy ever since the primary contributer
# started spreading their legs to claude.
# However, I've written these nix expressions to learn about packaging lispware
{
  writeText,
  callPackage,
  fetchFromGitHub,
  sbcl,
  sbclPackages,
  ncurses,
  makeWrapper,
  git,
}: let
  version = "2.3.0";
  vendoredLibs = {
    micros = callPackage ./micros.nix {};
    lem-mailbox = callPackage ./lem-mailbox.nix {};
    tree-sitter-cl = callPackage ./tree-sitter-cl.nix {};
    jsonrpc = sbclPackages.jsonrpc.overrideLispAttrs (old: {
      lispLibs =
        old.lispLibs
        ++ (with sbclPackages; [
          cl_plus_ssl
          quri
          fast-io
          trivial-utf-8
          event-emitter
          websocket-driver
          clack
          clack-handler-hunchentoot
        ]);
      systems = [
        "jsonrpc"
        "jsonrpc/transport/stdio"
        "jsonrpc/transport/tcp"
        "jsonrpc/transport/websocket"
      ];
    });
  };
in
  sbcl.buildASDFSystem {
    inherit version;
    pname = "lem";
    src = fetchFromGitHub {
      owner = "lem-project";
      repo = "lem";
      tag = "v${version}";
      hash = "sha256-itw/2jW813XFEUuQJRaFRH7DY6Hp/hATlN6uZbvRb2I=";
    };

    postPatch = ''
      sed -i '1i(pushnew :nix-build *features*)' lem.asd
    '';

    nativeLibs = [
      ncurses
      git
      makeWrapper
    ];

    lispLibs =
      (with sbclPackages; [
        iterate
        closer-mop
        trivia
        trivial-gray-streams
        trivial-types
        cl-ppcre
        inquisitor
        babel
        bordeaux-threads
        yason
        log4cl
        split-sequence
        str
        dexador
        cl-charms
        cl-setlocale
        esrap
        parse-number
        cl-package-locks
        async-process
        trivial-utf-8
        swank
        _3bmd
        _3bmd-ext-code-blocks
        lisp-preprocessor
        trivial-ws
        trivial-open-browser
      ])
      ++ (with vendoredLibs; [
        micros
        lem-mailbox
        jsonrpc
        tree-sitter-cl
      ]);

    systems = ["lem-ncurses" "tree-sitter-cl"];

    buildScript =
      writeText "build-lem.lisp"
      /*
      lisp
      */
      ''
        (defpackage :nix-cl-user (:use :cl))
        (in-package :nix-cl-user)

        ;; Load ASDF
        (load (concatenate 'string (sb-ext:posix-getenv "asdfFasl") "/asdf.fasl"))
        (asdf:initialize-output-translations '(:output-translations :disable-cache :inherit-configuration))

        ;; Load Systems
        (mapcar #'asdf:load-system (uiop:split-string (uiop:getenv "systems")))

        ;; Dump Image
        (setf uiop:*image-entry-point* #'lem:main)
        (uiop:dump-image "lem" :executable t :compression t)
      '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -Dm777 lem $out/bin

      wrapProgram $out/bin/lem \
        --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH"
        # --prefix DYLD_LIBRARY_PATH : "$DYLD_LIBRARY_PATH"

      runHook postInstall
    '';

    passthru = {
      inherit vendoredLibs;
    };
  }
