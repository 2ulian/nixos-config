{
  config,
  pkgs,
  ...
}: {
  specialisation = {
    kvm.configuration = {
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
    };

    virtualbox.configuration = {
      # Désactive KVM AU NIVEAU KERNEL
      boot.blacklistedKernelModules = [
        "kvm"
        "kvm_intel"
        "kvm_amd"
      ];

      # Active VirtualBox
      virtualisation.virtualbox.host.enable = true;

      # Optionnel mais recommandé
      virtualisation.virtualbox.host.enableExtensionPack = true;
    };
  };
}
