Documents use [Markdown][1] for a basic formating of plain text, specifically [GitHub Flavored Markdown][2]. 

→ [var/aliases/pandoc.sh](../var/aliases/pandoc.sh)

Use [Pandoc][3] to generate HTML pages from Markdown with <kbd>pandoc-html-article</kbd>. Include a table of content and section numbering with <kbd>pandoc-html-book</kbd>. Both Shell aliases use Pandoc templates to generate HTML pages including a [style sheet][5] describing document presentation: 

→ [var/lib/pandoc/html-article.template](../var/lib/pandoc/html-article.template)  
→ [var/lib/pandoc/html-book.template](../var/lib/pandoc/html-book.template)  
→ [var/lib/pandoc/light.css](../var/lib/pandoc/light.css)

For example to generate an HTML page from a document in this directory:

    » sudo apt install pandoc 
    » source ../source_me.sh
    » pandoc-html-book libvirt.md > libvirt.html

1. Install the `pandoc` package on [Debian][6] (cf. [Installing Pandoc][4])
2. Load the `pandoc-html-*` aliases into your shell environment with <kbd>source</kbd>.
3. Generate an HTML page from a Markdown file.

[1]: https://en.wikipedia.org/wiki/Markdown
[2]: https://help.github.com/categories/writing-on-github/
[3]: https://de.wikipedia.org/wiki/Pandoc 
[4]: http://pandoc.org/installing.html
[5]: https://en.wikipedia.org/wiki/Cascading_Style_Sheets
[6]: https://www.debian.org/

