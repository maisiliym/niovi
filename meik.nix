{ kor
, niovi
, krimyn
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

argz@{ nvim, ... }:
let
  inherit (kor) optionals;
  inherit (krimyn.spinyrz) izUniksDev saizAtList iuzColemak;

  aolPloginz = vimPlugins // vimPloginz;

  minVimLPloginz = with vimPloginz; [
    dwm-vim
    vim-visual-multi
    fzf-vim
    zoxide-vim
    astronauta-nvim
  ];

  medVimlPlogins = with aolPloginz; [
    nvim-yarp # UpdateRemotePlugin replacement
    gina-vim # git
    vista-vim # Tags
    vim-toml
    ron-vim
    tokei-vim
    vim-nix
    dhall-vim
    vim-markdown
    vim-ledger
    vim-surround
    vim-pager
    vim-rooter
    ultisnips
    vim-snippets
    bufferize-vim
    minimap-vim
  ];

  maxVimlPlogins = with aolPloginz; [
    vim-fugitive # git
    gv-vim
  ];

  minLuaPloginz = with vimPloginz; [
    plenary-nvim
    popup-nvim
    nvim-tree-lua
    lir-nvim
    completion-nvim
    completion-buffers
    nvim-treesitter
    nvim-treesitter-refactor
    nvim-bufferline-lua
    telescope-nvim
    FTerm-nvim
    gitsigns-nvim # bogi
    BufOnly-nvim
    nvim-autopairs
    nvim-fzf
    nvim-fzf-commands
    kommentary
  ];

  medLuaPloginz = with vimPloginz; [
    nvim-lspconfig
    lsp-status-nvim
    nvim-lspfuzzy
    nvim-web-devicons
    galaxyline-nvim
    nvim-colorizer-lua
    nvim-base16-lua
    nvim-lazygit
    fzf-lsp-nvim
    formatter-nvim
  ];

  maxLuaPloginz = with vimPloginz; [
    lspsaga-nvim
    nvim-treesitter-context
  ];

  vimlPloginz = minVimLPloginz
    ++ (optionals saizAtList.med medVimlPlogins)
    ++ (optionals saizAtList.max maxVimlPlogins);

  luaPloginz = minLuaPloginz
    ++ (optionals saizAtList.med medLuaPloginz)
    ++ (optionals saizAtList.max maxLuaPloginz);

  minPackages = [ ];

  medPackages = [
    llvmPackages_latest.clang
    universal-ctags
    go
    neovim-remote
    nixpkgs-fmt
  ];

  maxPackages = [ ghc cabal-install stack ];

  plugins = vimlPloginz ++ luaPloginz;

  packages = minPackages
    ++ (optionals (izUniksDev && saizAtList.med) (medPackages
    ++ (optionals saizAtList.max maxPackages)));

  niks = { };

in
niovi.meikPod {
  inherit nvim plugins niks packages;
}
