% Installing

### Dependencies

`pdsite` aims to keep its dependencies short and simple. The complete list is:

- [pandoc](http://pandoc.org/) (for all the heavy lifting)
- [tree](http://mama.indstate.edu/users/ice/tree/) (for generating file structures for navigation menus, etc)
- [webfs](http://linux.bytesex.org/misc/webfs.html) (optional: for easily viewing the site after building)

These are generally available through your system package manager's repositories (`brew`, `apt-get`, `yum`, `pacman`, etc)

### Installation

`pdsite` is just a shell script, so installation is fairly straightforward. If you use Git, you can just navigate to your preferred installation location and run:

```sh
git clone https://github.com/GordStephen/pdsite 
chmod 755 pdsite/pdsite
```

Alternatively, you can download and unpack a [release](https://github.com/GordStephen/pdsite/releases):

```sh
wget ...
unzip
chmod 755 pdsite/pdsite
```
In either case, you may wish to add the install location to your path for easy use in the future.
