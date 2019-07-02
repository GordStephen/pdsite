---
title: Creating a new theme
---

A `pdsite` theme can be as minimal as a folder containing a single `template.html` file
that provides a [pandoc template](http://pandoc.org/README.html#using-variables-in-templates)
for rendering HTML pages.
Arbitrary additional files (CSS, JS, 404 pages, etc) can be provided as well --
their contents and folder structure will just be copied verbatim into the site output directory.
The theme name is given by the name of the container folder
once it has been [copied into the themes subdirectory](/themes/choosing-themes#installing-new-themes).

