rothgar’s dotfiles
==================

Highly opinionated dotfiles for all of my computers. Many options were stolen 
and based off other peoples works. Here are some links

[prezto](http://github.com/sorin-ionescu/prezto) for majority of shell options

[tmux-plugins](https://github.com/tmux-plugins) for easy tmux config

[spf13-vim](https://github.com/spf13/spf13-vim) for vim config

[mathiasbynen dotfiles](https://github.com/mathiasbynens/dotfiles)

[whiteinge dotfiles](https://github.com/whiteinge/dotfiles)

[cowboy dotifles](https://github.com/cowboy/dotfiles)

Uses
----

I mostly spend time in Linux using Red Hat or Debian based distros
most of my dotfiles are oppinionated as such. I do minor work in OS X but still
rely on some configuration to work there.

Requirements
----

 * zsh 4.3.11+ (zprezto requirement)
 * tmux 1.9+ (not required but some shortcuts won’t work)
 * vim  7.3+ (spf13 requirement)
 * git 1.7+ (spf13 requirement)

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

