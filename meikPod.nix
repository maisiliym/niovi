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
, plugins ? [ ]
, ploginz ? [ ]
, niks ? { }
, packages ? [ ]
, luaModz ? [ ]
, luaCModz ? [ ]
, ...
}:
let
  inherit (builtins) map concatLists concatStringsSep filter
    concatMap readFile;
  inherit (kor) unique makeSearchPath optionalString;
  inherit (stdenv) mkDerivation;
  inherit (nvim) lua;

  korPloginz = [
    { spici = "lua"; drv = nvimPloginz.plenary-kor; }
  ];

  ploginz = (argz.ploginz or [ ]) ++ korPloginz;

  transitiveClosure = plugin: [ plugin ] ++
    (unique (concatLists (map transitiveClosure plugin.dependencies or [ ])));

  vimPloginz = map (p: p.drv) (filter (p: p.spici == "vim") ploginz);
  vimPlugins = plugins ++ vimPloginz;

  vimPluginDirz = concatMap transitiveClosure vimPlugins;

  korNiks = { inherit vimPluginDirz; };

  fainylNiks = niks // korNiks;

  nioviNiks = kynvyrt {
    neim = "niovi-niks";
    valiu = fainylNiks;
  };

  luaRidNiks = "";

  luaModz = (argz.luaModz or [ ]) ++ [ lua.pkgs.penlight ];
  luaCModz = (argz.luaCModz or [ ]) ++ [ lua.pkgs.mpack ];

  mkLuaCPath = drv: "${drv}/lib/lua/${drv.lua.luaversion}/?.so";

  mkLuaPaths = drv: [
    "${drv}/share/lua/${drv.lua.luaversion}/?.lua"
    "${drv}/share/lua/${drv.lua.luaversion}/?/init.lua"
  ];

  mkLuaPloginPaths = plogin:
    [ "${plogin.drv}/lua/?.lua" "${plogin.drv}/lua/?/init.lua" ];

  luaModulesPaths = concatStringsSep ";" (
    ((concatMap mkLuaPaths luaModz)) ++
    (concatMap mkLuaPloginPaths (filter (p: p.spici == "lua") ploginz))
  );

  luaCModulesPaths = concatStringsSep ";" (map mkLuaCPath luaCModz);

  loadLuaPathsKod = optionalString (luaModulesPaths != [ ]) ''
    package.path = package.path .. ";" .. [[${luaModulesPaths}]]
  '' + optionalString (luaCModulesPaths != [ ]) ''
    package.cpath = package.cpath .. ";" .. [[${luaCModulesPaths}]]
  '';

  runtimePaths = concatStringsSep "," vimPluginDirz;
  loadRuntimepath = ''
    vim.o.runtimepath = [[${runtimePaths}]]
  '';

  nioviLuaInit = readFile ./lua/niovi.lua;

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
