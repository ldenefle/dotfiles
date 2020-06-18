{ config, pkgs, ... }:

let
  relativeXDGConfigPath = "$HOME/.config";
  relativeXDGDataPath = "$HOME/.local/share";
  relativeXDGCachePath = "$HOME/.cache";
  host = {
    x86_64-darwin = "mac";
    x86_64-linux  = "linux";
  }.${builtins.currentSystem} or (throw "Unsupported system: ${builtins.currentSystem}");
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    ag
    ccache
    cmake
    cscope
    ctags
    curl
    exa
    fd
    direnv
    dfu-util
    git
    gitAndTools.hub
    go
    htop
    lorri
    mpd
    mpc_cli
    ncmpcpp
    neofetch
    niv
    pass
    perl
    pipenv
    poetry
    python3
    ranger
    tig
    tmux
    uncrustify
    wireguard
    wireguard-go
    wireguard-tools
    wget
    zsh
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile (./extra + ("/." + host + "_vimrc")) + builtins.readFile (./extra/.common_vimrc);

    plugins = with pkgs.vimPlugins; [
      # Syntax / Language Support ##########################
      vim-nix
      rust-vim # rust
      vim-go # go
      vim-markdown # markdown

      # UI #################################################
      wal-vim
      ayu-vim # colorscheme
      vim-tmux-navigator
      vim-cpp-enhanced-highlight

      # Editor Features ####################################
      vim-sensible
      vim-unimpaired
      vim-surround
      vim-repeat
      vim-commentary
      vim-easy-align
      vim-better-whitespace
      vim-bufkill

      # Buffer / Pane / File Management ####################
      fzf-vim # all the things

      # Panes / Larger features ############################
      vim-fugitive # Gblame
    ];
  };

  programs.zsh = {
    enable = true;
    history = {
      path = "${relativeXDGDataPath}/zsh/.zsh_history";
      size = 50000;
      save = 50000;
    };

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "be3882aeb054d01f6667facc31522e82f00b5e94";
          sha256 = "0w8x5ilpwx90s2s2y56vbzq92ircmrf0l5x8hz4g1nx3qzawv6af";
        };
      }
    ];

    sessionVariables = rec {
      NVIM_TUI_ENABLE_TRUE_COLOR = "1";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=3";
      EDITOR = "nvim";
      VISUAL = EDITOR;
      GIT_EDITOR = EDITOR;
      PATH = "$HOME/.local/bin:$PATH";
      TERM = "xterm-256color";
      FZF_DEFAULT_COMMAND = "fd --type f";
      LANG = "en_US.UTF-8";
      LC_ALL = "C";
      LANGUAGE = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
    };

    initExtra = builtins.readFile (./extra/common.zsh) + builtins.readFile (./extra + ("/" + host + ".zsh"));
  };

  programs.go = {
    enable = true;
    goPath = "_CODE/go";
  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
  nixpkgs.config.allowUnfree = true;
}
