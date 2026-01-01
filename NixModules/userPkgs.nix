{ config, lib, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [ # Place the packages you want to install bellow
    #vim
    #inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    #vscodium
    #firefoxpwa
    #vesktop #discord 
    #spotify
    #libreoffice-qt
    #hunspell
    #hunspellDicts.nb_NO
    #hunspellDicts.nn_NO
    #hunspellDicts.en_US
  ];

  #programs.firefox = {
  # nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  #};





  #programs.steam = {
  #	enable = true;
 	#	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #	localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	#};	

  
  #programs.gamescope = {
  #enable = true;
  #capSysNice = true;
  #};

  #programs.steam.gamescopeSession.enable = true;

}