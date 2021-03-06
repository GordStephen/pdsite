% Installing

### Dependencies

`pdsite` aims to keep its dependencies short and simple. The complete list is:

- [pandoc](http://pandoc.org/) (for all the heavy lifting)
- [tree](http://mama.indstate.edu/users/ice/tree/) (for generating file structures for navigation menus, etc)
- [webfs](http://linux.bytesex.org/misc/webfs.html) (optional: for easily viewing the site after building)

These are generally available through your system package manager's repositories (`brew`, `apt-get`, `yum`, `pacman`, etc)

### Installation

`pdsite` is just a shell script, so installation is fairly straightforward. For example, using Git:

```sh
cd ~
git clone https://github.com/GordStephen/pdsite .pdsite
chmod 744 .pdsite/bin/pdsite
```

At this point the script can be run from anywhere using `~/.pdsite/bin/pdsite`. You will probably want to add `~/.pdsite/bin` to your shell's PATH variable to be able to simply call `pdsite` in the future.
