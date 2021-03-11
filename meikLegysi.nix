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

argz@{ nvim, plugins, niks, packages, ... }:
let
  inherit (builtins) concatLists concatStringsSep;
  inherit (kor) flatten mapAttrsToList concatMap;
  inherit (krimyn.spinyrz) izUniksDev saizAtList iuzColemak;

  transitiveClosure = plugin: [ plugin ] ++
    (unique (concatLists (map transitiveClosure plugin.dependencies or [ ])));

  findDependenciesRecursively = plugins: concatMap transitiveClosure plugins;

  meikPloginzKod = packages:
    let
      packNamespace = "niovi";

      link = dir: pluginPath:
        "ln -sf ${pluginPath}/share/vim-plugins/* $out/pack/${packNamespace}/${dir}";

      packageLinks = { start ? [ ], opt ? [ ] }:
        let
          depsOfOptionalPlugins = subtractLists opt (findDependenciesRecursively opt);
          startWithDeps = findDependenciesRecursively start;
        in
        [ "mkdir -p $out/pack/${packNamespace}/start" ]
        ++ (builtins.map (link packNamespace "start") (unique (startWithDeps ++ depsOfOptionalPlugins)))
        ++ [ "mkdir -p $out/pack/${packNamespace}/opt" ]
        ++ (builtins.map (link packNamespace "opt") opt);

      packDir = stdenv.mkDerivation {
        name = "vim-pack-dir";
        src = ./.;
        installPhase = concatStringsSep "\n"
          (flatten (mapAttrsToList packageLinks packages));
        preferLocalBuild = true;
      };

    in
    ''
      set packpath^=${packDir}
      set runtimepath^=${packDir}
    '';

  aolPloginz = vimPlugins // vimPloginz;

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
