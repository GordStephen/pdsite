---
title: Choosing a theme
---

## Building with an installed theme

Setting the theme to be used during HTML generation is as simple as setting the `theme` variable in `.pdsite.yml`.
For example, in the configuration below, the theme is set to "default":

```yaml
# pdsite configuration

theme: default
inputextension: .md
outputfolder: .html

# Site-wide template variables

bootswatch: lumen 
sitename: "pdsite"
site-url: "https://pdsite.org"
site-base-path:
pagetitle-suffix: "Pandoc-backed static site generator"
footer: '<a href="https://github.com/GordStephen/pdsite">GitHub Repo</a> | <a href="https://github.com/GordStephen/pdsite/issues">Report an Issue</a>'
```

There's also a `bootswatch` template variable set to "lumen" -
the default theme is built on [Bootstrap](http://getbootstrap.com/)
and uses this optional parameter to further customize the site's look and feel
by using the corresponding [Bootswatch](http://bootswatch.com/) customizations.

## Installing new themes

Themes are stored in the the `themes` subdirectory of the pdsite installation folder (for example, `~/.pdsite/themes`).
Installing a new theme is just a matter of moving a folder with the theme contents into that subdirectory -
once the folder exists the theme can be used by setting the `theme` variable in a site's `.pdsite.yml` to the folder name.
