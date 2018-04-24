rothgar’s dotfiles
==================

Highly opinionated dotfiles for all of my computers. Many options were stolen 
and based off other peoples works. Here are some links

 * [tmux-plugins](https://github.com/tmux-plugins) for easy tmux configuration
 * [mathiasbynen dotfiles](https://github.com/mathiasbynens/dotfiles)
 * [whiteinge dotfiles](https://github.com/whiteinge/dotfiles)
 * [cowboy dotifles](https://github.com/cowboy/dotfiles)

Uses
----

I mostly spend time in Linux using Red Hat or Arch based distros
most of my dotfiles are oppinionated as such.

Requirements
----

 * zsh 4.3.11+
 * tmux 1.9+ (not required but some shortcuts won’t work)
 * vim  7.3+
 * git 1.7+

Install
----

Install with git

```
git clone https://github.com/rothgar/dotfiles.git ~/.dotfiles
```

run `~/.dotfiles/init/dotfiles-install.sh` to get the shell started
or selectively symlink files in the ln directory.

dotfiles-install will also install all dependant software [WIP] that the
the dotfiles rely on.

About
----

Folder definitions

 * `bin` - scripts and binaries that I find helpful. Should be put in $PATH
 * `init` - tool and scripts for initiallizing dotfiles (could probably be put in bin)
 * `ln` - symlink folder where ~/. files point
 * `zdotdir` - shell environment and options
