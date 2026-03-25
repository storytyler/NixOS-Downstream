{ config, pkgs, ... }:
{
  # Ensure backup directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/backups/hindsight 0755 root root -"
    "d /var/log 0755 root root -"
  ];

  # Backup service (one-shot job)
  systemd.services.hindsight-backup = {
    description = "Hindsight database backup";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${pkgs.hindsight-backup}/bin/hindsight-backup";
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  # Nightly timer (2 AM)
  systemd.timers.hindsight-backup = {
    description = "Nightly Hindsight backup at 2 AM";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      Persistent = true; # Run immediately if missed
      Unit = "hindsight-backup.service";
    };
  };

  # Add backup script to system packages
  environment.systemPackages = with pkgs; [ hindsight-backup ];
}
