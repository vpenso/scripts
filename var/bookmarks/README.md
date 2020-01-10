This directory contains files storing bookmarks to web-sites.

These files are used with the [`bookmarks`][01] program to open a selected 
web-site in a web-browser defined by `$BROWSER`.

File                           | Description
-------------------------------|-------------------------
[bin/bookmarks][01]            | Program to read bookmarks from this directory
[bin/rofi-bookmarks][02]       | Use `rofi` to select a bookmark
[var/aliases/bookmarks.sh][03] | Configure the environment

```bash
# link to the bookmarks within this repository
test -L ~/.bookmarks || \
        ln -s $SCRIPTS/var/bookmarks ~/.bookmarks
```


[01]: ../../bin/bookmarks
[02]: ../../bin/rofi-bookmarks
[03]: ../aliases/bookmarks.sh
