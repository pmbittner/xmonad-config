{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    # Haskell
    haskell.compiler.ghc9103
    haskell-language-server
    cabal-install

    # XMonad libraries
    haskellPackages.xmonad
    haskellPackages.xmonad-contrib

    # X11
    xorg.libX11
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXScrnSaver
    xorg.libXft
    xorg.libXext
  ];
}
