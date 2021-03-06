{ pkgs, username, homeDirectory, machineConf }:

############################
# Custom package snapshots #
############################
# NB. These are a necessary evil for when a version of a package,
#     which is not included in the nixpkgs repository, is needed.
#
#     This issue: https://github.com/NixOS/nixpkgs/issues/93327 explains
#     the needed procedure.
#
#     Package version search tool: https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=haskell-language-server
#
# TODO Maybe make a streamlined function for this?

let custom-ver-pkgs = {
  # Haskell Language Server
  hls = let pkgsSnapshot = import (builtins.fetchGit {
      name = "custom-hls-version";
      url = "https://github.com/nixos/nixpkgs-channels/";
      ref = "refs/heads/nixpkgs-unstable";                     
      rev = "2c162d49cd5b979eb66ff1653aecaeaa01690fcc";
    }) {}; in pkgsSnapshot.haskellPackages.haskell-language-server;


  # Qutebrowser (current version does not work for some reason...)
  qutebrowser = let pkgsSnapshot = import (builtins.fetchGit {
      name = "custom-qutebrowser-version";
      url = "https://github.com/nixos/nixpkgs-channels/";
      ref = "refs/heads/nixpkgs-unstable";                     
      rev = "c83e13315caadef275a5d074243c67503c558b3b";
    }) {}; in pkgsSnapshot.qutebrowser;

  # openjdk8 for minecraft
  openjdk = let pkgsSnapshot = import (builtins.fetchGit {
      name = "old-openjdk8";
      url = "https://github.com/nixos/nixpkgs-channels/";
      ref = "refs/heads/nixpkgs-unstable";                     
      rev = "2c162d49cd5b979eb66ff1653aecaeaa01690fcc";
    }) {}; in pkgsSnapshot.openjdk;
};

in

# Start of config set
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "21.03";

  # Packages
  home.packages = let rawPkgsList = with pkgs; [
    # Basic utils
    wget
    git
    dmenu
    xclip
    zip
    unzip
    scrot
    xorg.xev
    acpi
    sxhkd
    gnupg
    pinentry-gnome
    bc

    # Advanced Utils
    git-crypt
    rclone
    restic
    meld
    briss
    virtualbox # TODO: Consider if removing for virt-manager
    virt-manager

    # Terminal
    alacritty

    # Browsers
    firefox
    # TODO: wait until nixpkgs: qutebrowser
    transmission-gtk

    # Media
    mplayer
    ranger
    vlc
    ffmpeg
    zathura
    krita

    # Music
    audacity

    # Looks
    redshift
    feh

    # System management
    syncthing
    pass

    # Programming utils
    # neovim # TODO: Find out why this fails...
    # emacs # TODO: Setup doom emacs
    boxes
    # TODO haskellPackages.hindent
    # TODO Older version used below: haskellPackages.haskell-language-server

    # Programming
    stack
    nodejs # mainly for coc vim plugin

    # Desktop
    xorg.xmodmap
    xmobar

    # Games
    # TODO minecraft-server
    # TODO logmein-hamachi

    # Poli
    alloy5
  ] ++

  # Packages with custom version (See start of file)
  (with custom-ver-pkgs; [
    hls
    qutebrowser
  ]);

  # Remove machine ignored packages
  in let isNotIgnored = pkg: !(builtins.elem pkg machineConf.homeCore.ignoredPackages);
    in builtins.filter isNotIgnored rawPkgsList;

  ############
  # XSession #
  ############

  # Xsession/Xprofile
  xsession = {
    # TODO: Fix this overriding custom keyboard layout in nixos config
      enable = false;

    # Things that would go into ´~/.xprofile´
    initExtra = ''
      # Blue light is evil
      redshift -O 3000

      # Nature is relaxing
      feh --bg-scale ~/img/wp/forest.jpg

      # TODO: HACK: sxhkd needs to be restarted for some reason
      pkill sxhkd; sxhkd &
    '';
  };

  ############
  # Programs #
  ############

  # bash
  programs.bash = {
    enable = true;

    shellAliases = 

    # Helper functions to generate similar aliases
    #
    # TODO: make this work without nvim
    let makeOpenAndSearchAlias = needle: foldlv:
      "nvim -c '/\\<${needle}\\>' -c 'set foldlevel=${toString foldlv}' /etc/nixos/home/core.nix";

    in {
      # Hacks
      sudo = "sudo ";

      # Tweaking nixos is hard enough without having to type this abhorrent thing everytime...
      reb = "sudo nixos-rebuild switch";
      rebup = "sudo nixos-rebuild --upgrade swtich";

      # Automated way to edit automated config
      edit-config-dir = "cd /etc/nixos; sudo su";
      edit-config-file = "sudo $EDITOR /etc/nixos/configuration.nix";
      edit-home-core = "$EDITOR /etc/nixos/home/core.nix";
      edit-dots = "cd /etc/nixos/home/dotfiles";
      edit-todo = "$EDITOR /etc/nixos/todo.md";
      edit-home-pkgs = makeOpenAndSearchAlias "home.packages" 2;
      edit-home-aliases = makeOpenAndSearchAlias "shellAliases" 3;

      # Program-specific configuation editing
      edit-git-aliases = makeOpenAndSearchAlias "programs.git" 2;

      # Even faster ways to edit configuration
      ecd = "edit-config-dir";
      eh = "edit-home-core";
      ehp = "edit-home-pkgs";
      eha = "edit-home-aliases";
      ega = "edit-git-aliases";
      ecf = "edit-config-file";
      ecd = "edit-config-dir";

      # Build configuration
      fsw = "sudo nixos-rebuild switch";
      ssw = "sudo nix-channel --update; sudo nixos-rebuild --upgrade switch";
      fbt = "sudo nixos-rebuild boot";
      sbt = "sudo nix-channel --update; sudo nixos-rebuild --upgrade boot";

      # Better defaults
      ls = "ls --color=auto";
      clip = "xclip -selection clipboard";

      # Utilities
      cpp = "rsync -ah --progress";
      cx = "chmod +x";
      power = "acpi";
      computer-info = "neofetch";
      show-ip4 = "wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1";

      # Quick access to files
      real="zathura ~/books/music/the-real-book.pdf & disown; exit";
    };

    bashrcExtra = ''
      # Environmental variables
      export EDITOR=nvim
      export TERMINAL=alacritty
      export BROWSER=qutebrowser
      export MYVIMRC=/etc/nixos/home/dotfiles/nvim/

      # Vim is the way
      set -o vi

      # Use <c-s> to go forward in reverse-i-search(es)
      stty -ixon
    '';
  };

  # alacritty
  programs.alacritty = {
    enable = true;

    settings = {
      # TODO: font.size = machineConf.terminal.font.size;
      font.size = 12;
    };
  };

  # git
  programs.git = {
    enable = true;

    userEmail = "dincio.montesi@gmail.com";
    userName = "Bietola";
    
    aliases = {
      co = "checkout";
      s = "status";
      A = "add -A";
      c = "commit";
      cano = "commit --amend --no-edit";
      adog = "log --all --decorate --oneline --graph";
      b = "branch";
      sc = "stash clear";
      su = "stash --include-untracked";
      sp = "stash pop";
      p = "push";
      pf = "push --force-with-lease";
      shit = "reflog";
      r2 = "rebase --interactive HEAD~2";
      r3 = "rebase --interactive HEAD~3";
      r4 = "rebase --interactive HEAD~4";
    };

    extraConfig = {
      core.editor = "nvim";
      credential.helper = "store --file ~/.git-credentials";
      pull.rebase = "false";

      # Submodules
      diff.submodule = "log";
      status.submodulesummary = 1;
    };
  };

  # pass
  programs.password-store = {
    enable = true;
  };

  # vim
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Basic
      vimwiki
      vim-vsnip
      # TODO: Make Custom: dsf-vim
      vim-exchange
      vim-tabpagecd
      delimitMate
      vim-surround
      vim-dispatch
      vim-commentary
      vim-fugitive
      vim-vinegar
      vim-unimpaired
      vim-repeat
      sideways-vim
      ctrlp-vim

      # Cosmetic
      # TODO: Fix characters: vim-airline
      # vim-airline-themes

      # Snippets
      ultisnips

      # Hypertext
      vim-orgmode

      # Programming
      vim-slime
      coc-nvim
      # Nix
      vim-nix
      # Rust
      # TODO: Make Custom: ron-vim
      # Lisp dialects.
      vim-sexp
      vim-sexp-mappings-for-regular-people

      # Colorschemes.
      # sacredforest-vim
      iceberg-vim

      # Poli.
      # TODO: Make custom: vim-alloy
    ];
    extraConfig = builtins.readFile ./dotfiles/nvim/init.vim;
  };

  # xmonad
  xsession.windowManager.xmonad = {
    enable = true;

    enableContribAndExtras = true;
    extraPackages = hpkgs: [
      hpkgs.xmonad
      hpkgs.xmonad-contrib
      hpkgs.xmonad-extras
    ];

    config = ./dotfiles/xmonad/xmonad.hs;
  };

  # gpg
  services.gpg-agent = {
    enable = true;
  };

  # sxhkd
  services.sxhkd = {
    enable = true;

    extraConfig = builtins.readFile ./dotfiles/sxhkd/sxhkdrc;
  };

  # syncthing
  services.syncthing = {
    enable = true;
  };

  # Qutebrowser
  # TODO: Make this work
  # programs.qutebrowser = {
    # enable = true;

    # extraConfig = builtins.readFile ./dotfiles/qutebrowser/config.py;
  # };
}
