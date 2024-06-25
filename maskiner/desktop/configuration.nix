# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  myhostname,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
	../../config/base.nix
	../../config/users.nix
	../../shared/nginx.nix
  ];

	environment.systemPackages = with pkgs; [
		unstable.lego
	];
networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 80 443 8384 22000];
  allowedUDPPortRanges = [
    { from = 4000; to = 4007; }
    { from = 8000; to = 8010; }
  ];
};
   networking.firewall.allowedUDPPorts = [ 22000 21027 ];

	services = {
		openssh = {
			enable = true;
			ports = [55502];
			settings = {
				PermitRootLogin = "no";
				PasswordAuthentication = false;
				X11Forwarding = true;
			};
			extraConfig = ''
			  AllowUsers fw ios
			'';
		};
		syncthing = {
			enable = true;
			user = "fw";
			dataDir = "/home/fw/syncthing";
			configDir = "/home/fw/.config/syncthing";
			overrideDevices = true;     # overrides any devices added or deleted through the WebUI
			overrideFolders = true;     # overrides any folders added or deleted through the WebUI
		  guiAddress = "0.0.0.0:8384";
			settings = {
			  devices = {
				# "device1" = { id = "DEVICE-ID-GOES-HERE"; };
				# "device2" = { id = "DEVICE-ID-GOES-HERE"; };
			  };
			  folders = {
				"Documents" = {         # Name of folder in Syncthing, also the folder ID
				  path = "/home/fw/docs";    # Which folder to add to Syncthing
				  # devices = [ "device1" "device2" ];      # Which devices to share the folder with
				};
			  };
			};
	  };
	};


  security.rtkit.enable = true;
  networking.hostName = myhostname;

  services.xserver.dpi = 100;

  system.stateVersion = "23.11";
}
