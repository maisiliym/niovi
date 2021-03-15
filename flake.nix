{
  description = "niovi";

  outputs = { self }: {
    HobUyrldz = hob: {
      meik = {
        modz = [ "pkgs" "uyrld" ];
        lamdy = import ./meikPod.nix;
        self = null;
      };

      meikLegysi = {
        modz = [ "pkgs" "pkdjz" ];
        lamdy = import ./meikLegysi.nix;
      };

      nvim = {
        modz = [ "pkgs" "pkdjz" ];
        lamdy = import ./nvim.nix;
        self = hob.neovim.maisiliym.mein;
      };

      pod = {
        modz = [ "uyrld" ];
        lamdy = import ./pod.nix;
        inherit self;
      };

    };
  };
}
