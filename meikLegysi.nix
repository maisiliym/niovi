{ self
, kor
, kynvyrt
, nvimPloginz
, stdenv
, writeText
, symlinkJoin
, makeWrapper
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
  inherit (builtins) map unique concatLists concatStringsSep filter;
  inherit (kor) concatMap makeSearchPath;
  inherit (nvim) lua;

  korPloginz = [
    { spici = "lua"; drv = nvimPloginz.plenary-kor; }
  ];

  ploginz = argz.ploginz ++ korPloginz;

  transitiveClosure = plugin: [ plugin ] ++
    (unique (concatLists (map transitiveClosure plugin.dependencies or [ ])));

  vimPloginz = map (p: p.dir) (filter (p: p.spici == "vim") ploginz);
  vimPlugins = unique (plugins ++ vimPloginz);

  vimPluginDirz = concatMap (transitiveClosure vimPlugins);

  korNiks = { inherit vimPluginDirz; };

  fainylNiks = niks // korNiks;

  nioviNiks = kynvyrt {
    neim = "niovi-niks.msgpack";
    valiu = fainylNiks;
  };

  luaRidNiks = "";

  luaModz = argz.luaModz ++ [ lua.pkgs.penlight ];
  luaCModz = argz.luaCModz ++ [ lua.pkgs.mpack ];

  mkLuaCPath = drv: "${drv}/lib/lua/${drv.lua.luaversion}/?.so";

  mkLuaPaths = drv: [
    "${drv}/share/lua/${drv.lua.luaversion}/?.lua"
    "${drv}/share/lua/${drv.lua.luaversion}/?/init.lua"
  ];

  mkLuaPloginPaths = plogin:
    [ "${plogin}/lua/?.lua" "${plogin}/lua/?/init.lua" ];

  luaModulesPaths = concatStringsSep ";" (
    ((concatMap mkLuaPaths luaModz)) ++
    (concatMap mkLuaPloginPaths (filter (p: p.spici == "lua") ploginz))
  );

  luaCModulesPaths = concatStringsSep ";" (map mkLuaCPath luaCModz);

  loadLuaPathsKod = optionalString (luaModz != [ ]) ''
    package.path = package.path .. ";" .. [[${luaModulesPaths}]]
  '' + optionalString (luaCModz != [ ]) ''
    package.cpath = package.cpath .. ";" .. [[${luaCModulesPaths}]]
  '';

  runtimePaths = concatStringsSep "," vimPluginDirz;
  loadRuntimepath = ''
    vim.o.runtimepath = [[${runtimePaths}]]
  '';

  nioviLuaInit = readfile ./lua/niovi.lua;

  initLuaKod = loadLuaPathsKod + nioviLuaInit;

  initLua = writeText "niovi-init.lua" initLuaKod;

  packagesPath = makeSearchPath "bin" packages;

  pod = mkDerivation {
    name = "niovi";
    version = self.shortRev;

    buildPhase = ''
      mkdir -p $out/bin
    '';

    installPhase = ''
      makeWrapper ${nvim}/bin/nvim $out/bin/nvi \
      --set VIMRUNTIME ${nvim}/share/nvim/runtime \
      --set PATH ${packagesPath} \
      --set NIOVINIKS ${nioviNiks} \
      -u ${initLua}
    '';

    nativeBuildInputs = [ makeWrapper ];
  };

in
pod
