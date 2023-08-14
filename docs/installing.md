---
title: Installing
---

<!--
SPDX-FileCopyrightText: 2016-2019 Gord Stephen <gord@gordstephen.ca>
SPDX-FileCopyrightText: 2022 Robin Vobruba <hoijui.quaero@gmail.com>

SPDX-License-Identifier: CC0-1.0
-->

### Dependencies

`pdsite` aims to keep its dependencies short and simple.
The complete list is:

- [pandoc](http://pandoc.org/) -
  for all the heavy lifting
- []
- [busybox](https://www.busybox.net/) (optional, usually pre-installed) -
  for local HTTP hosting of the the site after building

These are generally available through your systems package manager's repositories (`brew`, `apt-get`, `yum`, `pacman`, etc)

### Installation

`pdsite` is just a shell script, so installation is fairly straightforward. For example, using Git:

```sh
cd ~
git clone https://github.com/GordStephen/pdsite .pdsite
chmod 744 .pdsite/bin/pdsite
```

At this point, the script can be run from anywhere using `~/.pdsite/bin/pdsite`.
You will probably want to add `~/.pdsite/bin` to your shell's `PATH` variable
to be able to simply call `pdsite` in the future:

```sh
export PATH="$PATH:$HOME/.pdsite/bin"
echo "PATH=\"\$PATH:\$HOME/.pdsite/bin\"" >> "$HOME/.profile"
```
