{
config, 
lib, 
pkgs,
... }: {
    programs.gpg = {
      enable = true;
      publicKeys = []; # see https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys
      settings = {
        default-key = "A7FB930FB8597407AEAB96236FEB23FCF209BDB0";
      };
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 36000;
      maxCacheTtl = 36000;
      defaultCacheTtlSsh = 36000;
      maxCacheTtlSsh = 36000;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry;
    };  
}
