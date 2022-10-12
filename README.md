# My Dotfiles

## To do

- [ ] Create an install script
- [x] Make `packer.nvim` bootstrap
- [ ] Make servers and formatters lists dependent on installed languages:
  - `vim.fn(go)` -> `shfmt` & `yamlfmt`
  - `vim.fn(cargo)` -> `shellharden`

## FAQ

- **In what order are zsh startup files sourced?**

This is explained in detail in [zsh docs](https://zsh.sourceforge.io/Doc/Release/Files.html#Startup_002fShutdown-Files):

> Commands are first read from /etc/zshenv; this cannot be overridden. [...] Commands are then read from $ZDOTDIR/.zshenv. If the shell is a login shell, commands are read from /etc/zprofile and then $ZDOTDIR/.zprofile. Then, if the shell is interactive, commands are read from /etc/zshrc and then $ZDOTDIR/.zshrc. Finally, if the shell is a login shell, /etc/zlogin and $ZDOTDIR/.zlogin are read.

In other words, this is the order in which these files get read. **Keep in mind that it reads first from the system-wide file (i.e. `/etc/zshenv`) then from the file in your home directory (`~/.zshenv`):**

`.zshenv` → `.zprofile` → `.zshrc` → `.zlogin` → `.zlogout`
