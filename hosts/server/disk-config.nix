{ ... }: {
  disko.devices = {
    disk = {
      # OS drive
      os = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            bios = {
              size = "1M";
              type = "EF02";
            };
            boot = {
              size = "512M";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };

      # QuestDB ZFS pool drive
      questdb = {
        device = "/dev/nvme1n1";
        type = "disk";
        content = {
          type = "zfs";
          pool = "questdb";
        };
      };
    };

    zpool = {
      questdb = {
        type = "zpool";
        options.ashift = "12";
        rootFsOptions = {
          compression = "zstd";
          atime = "off";
        };
        mountpoint = "/home/fjk/.questdb";
      };
    };
  };
}
