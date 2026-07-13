{
  description = "Minimal NixOS installation media";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  outputs = {
    self,
    nixpkgs,
  }: {
    nixosConfigurations = {
      exampleIso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({
            pkgs,
            modulesPath,
            ...
          }: {
            imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
            environment.systemPackages = [pkgs.llama-cpp];

            networking.firewall.enable = true;
            networking.firewall.allowedTCPPorts = [
              # SSHD
              22

              # Browsing
              80
              443
            ];

            services.tailscale.enable = true;

            systemd.oomd.enable = true;

            services.openssh = {
              enable = true;
              settings = {
                PasswordAuthentication = false;
                KbdInteractiveAuthentication = false;
                PermitRootLogin = "no";
                AllowUsers = ["git"];
              };
            };
          })
        ];
      };
    };
  };
}
