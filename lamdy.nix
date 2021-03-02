{ stdenv }:

stdenv.mkDerivation {
  pname = "niovi";
  version = self.shortRev;
  src = self;

}
