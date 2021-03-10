{ kor
, krimyn
, input
, stdenv
, writeText
, python3Packages
, tree-sitter
, tree-sitter-parsers
, wrapNeovimUnstable
}:

argz@{ nvim, ... }:
let
  inherit (kor) mapAttrsToList;
  inherit (krimyn.spinyrz) izUniksDev saizAtList iuzColemak;

  findDependenciesRecursively = plugins: lib.concatMap transitiveClosure plugins;

  meikPloginzKod = packages:
    let
      packNamespace = "niovi";

      link = (dir: pluginPath: "ln -sf ${pluginPath}/share/vim-plugins/* $out/pack/${packNamespace}/${dir}");

      packageLinks = { start ? [ ], opt ? [ ] }:
        let
          depsOfOptionalPlugins = lib.subtractLists opt (findDependenciesRecursively opt);
          startWithDeps = findDependenciesRecursively start;
        in
        [ "mkdir -p $out/pack/${packNamespace}/start" ]
        ++ (builtins.map (link packNamespace "start") (lib.unique (startWithDeps ++ depsOfOptionalPlugins)))
        ++ [ "mkdir -p $out/pack/${packNamespace}/opt" ]
        ++ (builtins.map (link packNamespace "opt") opt);

      packDir = stdenv.mkDerivation {
        name = "vim-pack-dir";
        src = ./.;
        installPhase = lib.concatStringsSep "\n"
          (lib.flatten (mapAttrsToList packageLinks packages));
        preferLocalBuild = true;
      };

    in
    ''
      set packpath^=${packDir}
      set runtimepath^=${packDir}
    '';

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

  pod = wrapNeovimUnstable nvim { };

  /* meikPod {
    Iuzyr = {
      neim = "niovi";
      siskol = [ "${nvim}/bin/nvim" "-u" "${initLua}" ];
      niksiz = ploginz ++ ekzykiutybylz;
      niksiSpiciz = {
        Eksykiutybyl = true;
        VimPlogin = true;
      };
    };
  }; */

in
pod
