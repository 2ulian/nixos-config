{
  config,
  pkgs,
  ...
}: {
  # Manage the virtualization services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  boot.kernelParams = [
    "intel_iommu=on" # or "amd_iommu=on"
    "iommu.strict=1"
  ];

  services.spice-vdagentd.enable = true;

  users.users.fellwin.extraGroups = ["libvirtd"];
}
