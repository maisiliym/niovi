{ kor
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
  inherit (builtins) map concatLists concatStringsSep;
  inherit (kor) concatMap;

  meikPackDir = plugins:
    let
      transitiveClosure = plugin: [ plugin ] ++
        (unique (concatLists (map transitiveClosure plugin.dependencies or [ ])));

      dependencies = concatMap transitiveClosure plugins;

      packTarget = "$out/pack/${niovi}/start";

      link = pluginPath:
        "ln -sf ${pluginPath}/share/vim-plugins/* ${packTarget}";

      linkPlugin = plugin:
        map link (unique (dependencies));

    in
    stdenv.mkDerivation {
      name = "niovi-pack-dir";
      src = ./.;

      installPhase = concatStringsSep "\n"
        [ "mkdir -p ${packTarget}" ] ++ (map linkPlugin plugins);

      preferLocalBuild = true;
    };

  packDir = meikPackDir plugins;

  setRuntime = ''
    set runtimepath^=${packDir}
  '';

  initLuaKod = "";

  initLua = writeText "niovi-init.lua" initLuaKod;

  pod = wrapNeovimUnstable nvim { };

in
pod
