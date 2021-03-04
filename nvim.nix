{ self
, stdenv
, lib
, cmake
, gettext
, msgpack
, libtermkey
, libiconv
, libuv
, luajit
, ncurses
, pkgconfig
, unibilium
, wl-clipboard
, gperf
, libvterm-neovim
, utf8proc
, tree-sitter
}:
let
  nvimLuaEnv = luajit.withPackages (ps: (with ps; [ lpeg luabitop mpack ]));

in
stdenv.mkDerivation {
  pname = "nvim";
  version = self.shortRev;
  src = self;

  dontFixCmake = true;
  enableParallelBuilding = true;

  buildInputs = [
    gperf
    libtermkey
    libuv
    libvterm-neovim
    luajit.pkgs.luv.libluv
    msgpack
    ncurses
    nvimLuaEnv
    unibilium
    utf8proc
    tree-sitter
  ];

  doCheck = false;

  checkPhase = ''
    make functionaltest
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkgconfig
  ];


  postPatch = ''
    substituteInPlace src/nvim/version.c --replace NVIM_VERSION_CFLAGS "";
  '';

  disallowedReferences = [ stdenv.cc ];

  cmakeFlags = [
    "-DGPERF_PRG=${gperf}/bin/gperf"
    "-DLUA_PRG=${nvimLuaEnv.interpreter}"
    "-DLIBLUV_LIBRARY=${luajit.pkgs.luv}/lib/lua/${luajit.luaversion}/luv.so"
  ];

  hardeningDisable = [ "fortify" ];

  postInstall = ''
    sed -i -e "s|'wl-copy|'${wl-clipboard}/bin/wl-copy|g" $out/share/nvim/runtime/autoload/provider/clipboard.vim
  '';

}
