---
toc: n
...

# pdsite
`pdsite` is a [Pandoc](http://pandoc.org/)-backed static site generator for Unix-like systems (including OSX, Linux, and BSD). It's comprised of a single shell script and has no dependencies on particular programming environments: it arose out of a desire for [MkDocs](http://www.mkdocs.org/)-like functionality with broader input format support and without the Python dependencies.

### Fully decoupled content and presentation
`pdsite` is built around the premise that content should be able to be kept completely seperate from presentation. Many site generators require both written content and visual presentation resources to be stored under a single path or Git repository: `pdsite` allows standalone file hierarchies (with content formatted in Markdown, Emacs org-mode, LaTex, etc) to be easily converted to linked HTML via an independently-specified theme. As such, switching HTML themes is just a matter of changing a line in a config file and rebuilding the site.

### Minimal dependencies
`pdsite` is built on standard Unix tools for portability (apologies if you use Windows). Its few [dependencies](installing#dependencies) are widely-available as tiny precompiled binaries (except for Pandoc, which is widely-available as a moderately-sized precompiled binary).
