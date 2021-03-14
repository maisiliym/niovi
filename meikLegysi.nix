{ kor
, input
, stdenv
, writeText
, python3Packages
, tree-sitter
, tree-sitter-parsers
, wrapNeovimUnstable
}:

argz@
{ nvim
, plugins
, ploginz
, niks
, packages
, luaModz
, luaCModz
, ...
}:
let
  inherit (builtins) map concatLists concatStringsSep;
  inherit (kor) concatMap;
  inherit (nvim) lua;

  transitiveClosure = plugin: [ plugin ] ++
    (unique (concatLists (map transitiveClosure plugin.dependencies or [ ])));

  ploginDirz = concatMap (uniques
    ((transitiveClosure plugins) ++ ((p: transitiveClosure p.dir) ploginz))
  );

  runtimePaths = concatStringsSep "," ploginDirz;

  setRuntime = ''
    set runtimepath^=${packDir}
  '';

  korNiks = { inherit runtimePaths; };

  fainylNiks = niks // korNiks;

  luaRidNiks = "";

  luaCModz = argz.luaCModz ++ [ lua.pkgs.mpack ];

  mkLuaCPath = drv: "${drv}/lib/lua/${drv.lua.luaversion}/?.so";

  mkLuaPaths = drv: [
    "${drv}/share/lua/${drv.lua.luaversion}/?.lua"
    "${drv}/share/lua/${drv.lua.luaversion}/?/init.lua"
  ];

  luaModulesPaths = concatStringsSep ";"
    (optionals (luaModz != [ ]) (concatMap mkLuaPaths luaModz));

  luaCModulesPaths = concatStringsSep ";"
    (optionals (luaCModz != [ ]) (map mkLuaCPath luaCModz));

  loadLuaPathsKod = optionalString (luaModz != [ ]) ''
    package.path = package.path .. ";" .. [[${luaModulesPaths}]]
  '' + optionalString (luaCModz != [ ]) ''
    package.cpath = package.cpath .. ";" .. [[${luaCModulesPaths}]]
  '';

  nioviLuaInit = readfile ./lua/niovi.lua;

  initLuaKod = loadLuaPathsKod + nioviLuaInit;

  initLua = writeText "niovi-init.lua" initLuaKod;

  pod = wrapNeovimUnstable nvim { };

in
pod
