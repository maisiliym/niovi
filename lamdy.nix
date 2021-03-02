{ self
, kor
, krimyn
, input
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

stdenv.mkDerivation {
  pname = "niovi";
  version = self.shortRev;
  src = self;

}
