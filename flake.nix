{
  description = "niovi";

  outputs = { self }: {
    HobUyrldz = hob: {
      meik = {
        modz = [ "pkgs" "pkdjz" "uyrld" "krimyn" ];
        lamdy = import ./meik.nix;
        self = null;
      };

      meikPod = {
        modz = [ "pkgs" "pkdjz" ];
        lamdy = import ./meikPod.nix;
        inherit self;
      };

      nvim = {
        modz = [ "pkgs" "pkdjz" ];
        lamdy = import ./nvim.nix;
        self = hob.neovim.mein;
      };

      pod = {
        modz = [ "uyrld" ];
        lamdy = import ./pod.nix;
        inherit self;
      };

    };
  };
}
