{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;
  services.tailscale.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys =
    [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOodpLr+FDRyKyHjucHizNLVFHZ5AQmE9GmxMnOsSoaw pimkunis@thinkpadpim"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAE0p+dl2wU+zS2lBqnzD6GS1+IjQhwumpvSWpi6eBSxAAAACnNzaDpnaXRodWI="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIB/elARZbd2S351cQX+y2dvs5utOgs6azhh371bGju2BAAAAEHNzaDpub2x0ZS1naXRodWI="
    ]
    ++ (args.extraPublicKeys or []); # this is used for unit-testing this module and can be removed if not needed

  system.stateVersion = "24.05";
}
