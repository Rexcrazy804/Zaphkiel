{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  which,
  gcc-arm-embedded-14,
  zlib,
  libpng,
  zeldatmc,
}:
stdenv.mkDerivation (final: {
  __structuredAttrs = true;

  inherit (zeldatmc) src;
  pname = "zeldatmc-tools";
  version = "unstable";

  nativeBuildInputs = [
    gcc-arm-embedded-14
    which
    cmake
  ];

  buildInputs = [
    zlib
    libpng
  ];

  preConfigure = ''
    pushd tools
  '';

  vendored = {
    project_content = fetchFromGitHub {
      owner = "aminya";
      repo = "project_options";
      tag = "v0.15.1";
      hash = "sha256-WCT4RVk4Ijd2Wvcf0T5MymsSNvAAt96V45HOBJaFohE=";
    };
    json = fetchFromGitHub {
      owner = "ArthurSonzogni";
      repo = "nlohmann_json_cmake_fetchcontent";
      tag = "v3.10.4";
      hash = "sha256-j5usu5wPq2tw5YiNF6UC6D+varafyYde38Od3F+XE5M=";
    };

    fmt = fetchFromGitHub {
      owner = "fmtlib";
      repo = "fmt";
      tag = "11.0.2";
      hash = "sha256-IKNt4xUoVi750zBti5iJJcCk3zivTt7nU12RIf8pM+0=";
    };
    CLI11 = fetchFromGitHub {
      owner = "CLIUtils";
      repo = "CLI11";
      tag = "v2.1.2";
      hash = "sha256-I150pDmaHY+RbHMr28f4xdggMB2ZhUNBGgOcsvuiQ3w=";
    };
  };

  cmakeFlags = let
    inherit (lib) cmakeFeature;
  in [
    (cmakeFeature "FETCHCONTENT_SOURCE_DIR__PROJECT_OPTIONS" "${final.vendored.project_content}")
    (cmakeFeature "FETCHCONTENT_SOURCE_DIR_JSON" "${final.vendored.json}")
    (cmakeFeature "FETCHCONTENT_SOURCE_DIR_FMT" "${final.vendored.fmt}")
    (cmakeFeature "FETCHCONTENT_SOURCE_DIR_CLI11" "${final.vendored.CLI11}")
    (cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];
})
