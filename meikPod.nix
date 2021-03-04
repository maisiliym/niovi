{ kor
, krimyn
, input
, meikPod
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
  inherit (krimyn.spinyrz) izUniksDev saizAtList iuzColemak;

  aolPloginz = pkgs.vimPlugins // vimPloginz;

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
    neogit # bogi
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

  eneibyldPloginz = vimlPloginz ++ luaPloginz;

  minPackages = with pkgs; [ ];

  medPackages = with pkgs; [
    llvmPackages_latest.clang
    universal-ctags
    go
    neovim-remote
    nixpkgs-fmt
    sqlite
  ];

  maxPackages = with pkgs; [ ghc cabal-install stack ];

  eneibyldEksykiutybylz = minPackages
    ++ (optionals (izUniksDev && saizAtList.med) (medPackages
    ++ (optionals saizAtList.max maxPackages)));

  spesyfai = {
    VimPlogin = niks: { VimPlogin = niks; };
    Eksykiutybyl = niks: { Eksykiutybyl = niks; };
  };

  ploginz = map spesyfai.VimPlogin eneibyldPloginz;
  ekzykiutybylz = map spesyfai.Eksykiutybyl eneibyldEksykiutybylz;

  initLuaKod = "";

  initLua = writeText "niovi-init.lua" initLuaKod;

  pod = meikPod {
    Iuzyr = {
      neim = "niovi";
      siskol = [ "${nvim}/bin/nvim" "-u" "${initLua}" ];
      niksiz = ploginz ++ ekzykiutybylz;
      niksiSpiciz = {
        Eksykiutybyl = true;
        VimPlogin = true;
      };
    };
  };

in
pod
