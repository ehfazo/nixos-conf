{ stdenv, pkgs }:

stdenv.mkDerivation {
  pname = "sddm-gruvbox";
  version = "debug";

  src = pkgs.fetchFromGitHub {
      owner = "ehfazo";
      repo = "sddm-gruvbox";
      rev = "theme";
      sha256 = "sha256-oM5PxNO0RTeOrWZ19gILnzhE43D4FVs6+n0enrofA6E=";
    }; 
  installPhase = ''
    mkdir -p $out/share/sddm/themes/sddm-gruvbox
    cp -R ./* $out/share/sddm/themes/sddm-gruvbox/
  '';
}
