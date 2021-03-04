{ self
, kor
, krimyn
, input
, meikPraimyr
, stdenv
, writeText
, vimPloginz
, vimPlugins
, neovim-remote
, python3Packages
, tree-sitter
, tree-sitter-parsers
, llvmPackages_latest
, cmake-language-server
, haskell-language-server
, universal-ctags
, rust-analyzer
, rnix-lsp
, nixpkgs-fmt
, gopls
, go
, ghc
, cabal-install
, stack
}:
let
  packages = { };

  Praimyr = meikPraimyr {
    neim = "niovi";
    praimyr = [ "${bild}/bin/nvi" ];
    env = {
      PATH = packages ++ [ bild ];
    };
  };

  meik = { ploginz }:
    let
      ploginzTri = { };

    in
    stdenv.mkDerivation {
      pname = "niovi";
      version = self.shortRev;
      src = self;
    };

  bild = meik { };

in
Praimyr
