# My Dotfiles

![latest-setup](./screenshots/2022_12_18.png)

## Software I use

* [`ghostty`](https://github.com/ghostty-org/ghostty): a blazingly fast terminal, written in rust.
* [`karabiner elements`](https://github.com/pqrs-org/Karabiner-Elements): a powerful utility for keyboard customization on macOS.
* [`lazygit`](https://github.com/jesseduffield/lazygit): simple terminal UI for git commands.
* [`neovim`](https://github.com/neovim/neovim): a vim-fork focused on extensibility and usability.
* [`aerospace`](https://github.com/nikitabobko/AeroSpace): AeroSpace is an i3-like tiling window manager for macOS
* [`sketchybar`](https://github.com/FelixKratz/SketchyBar): a highly customisable macOS status bar replacement.
* [`tmux`](https://github.com/tmux/tmux): a terminal multiplexer.
* [`zsh`](https://sourceforge.net/p/zsh/code/ci/master/tree/).

Everything is installed with [`homebrew`](https://brew.sh/), the missing package manager for macOS (or Linux).

## References and links

- [scripts](https://github.com/baggiponte/scripts): a place to home some functions that grew out of my [dotfiles](./zsh/include/functions.zsh).

## FAQ

- **In what order are zsh startup files sourced?**

This is explained in detail in [zsh docs](https://zsh.sourceforge.io/Doc/Release/Files.html#Startup_002fShutdown-Files):

> Commands are first read from /etc/zshenv; this cannot be overridden. [...] Commands are then read from $ZDOTDIR/.zshenv. If the shell is a login shell, commands are read from /etc/zprofile and then $ZDOTDIR/.zprofile. Then, if the shell is interactive, commands are read from /etc/zshrc and then $ZDOTDIR/.zshrc. Finally, if the shell is a login shell, /etc/zlogin and $ZDOTDIR/.zlogin are read.

In other words, this is the order in which these files get read. **Keep in mind that it reads first from the system-wide file (i.e. `/etc/zshenv`) then from the file in your home directory (`~/.zshenv`):**

`.zshenv` → `.zprofile` → `.zshrc` → `.zlogin` → `.zlogout`
