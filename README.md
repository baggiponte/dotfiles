# My Dotfiles

Bootstrap a new Mac:

```sh
curl -fsSL https://raw.githubusercontent.com/baggiponte/dotfiles/main/install.sh | zsh
```

![latest-setup](./screenshots/2022_12_18.png)

## Software I use

Everything is installed with [`homebrew`](https://brew.sh/).

## Install script

[`install.sh`](./install.sh) orchestrates the setup by sourcing modules from [`install/`](./install/):

| Module | What it does |
|---|---|
| [`prerequisites`](./install/prerequisites.zsh) | Installs Xcode CLI tools, accepts licence, configures `ZDOTDIR` in `/etc/zshenv` |
| [`packages`](./install/packages.zsh) | Installs Homebrew (if missing), runs `brew bundle` from [`Brewfile`](./Brewfile), sets up Docker plugins |
| [`config`](./install/config.zsh) | Exports `XDG_*` dirs, creates symlinks (`.gitconfig`, iCloud) |
| [`python`](./install/python.zsh) | Installs Python versions (3.10–3.13) via uv |
| [`apply-macos-defaults`](./install/apply-macos-defaults.zsh) | Applies macOS system settings — Dock, Finder, keyboard, mouse, trackpad, Stage Manager, screenshots, text substitutions, and compiles the bat theme |

## References and links

- [scripts](https://github.com/baggiponte/scripts): a place to home some functions that grew out of my [dotfiles](./zsh/include/functions.zsh).

## FAQ

- **In what order are zsh startup files sourced?**

This is explained in detail in [zsh docs](https://zsh.sourceforge.io/Doc/Release/Files.html#Startup_002fShutdown-Files):

> Commands are first read from /etc/zshenv; this cannot be overridden. [...] Commands are then read from $ZDOTDIR/.zshenv. If the shell is a login shell, commands are read from /etc/zprofile and then $ZDOTDIR/.zprofile. Then, if the shell is interactive, commands are read from /etc/zshrc and then $ZDOTDIR/.zshrc. Finally, if the shell is a login shell, /etc/zlogin and $ZDOTDIR/.zlogin are read.

In other words, this is the order in which these files get read. **Keep in mind that it reads first from the system-wide file (i.e. `/etc/zshenv`) then from the file in your home directory (`~/.zshenv`):**

`.zshenv` → `.zprofile` → `.zshrc` → `.zlogin` → `.zlogout`
