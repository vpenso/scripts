Documents use [Markdown][1], specifically [GitHub Flavored Markdown][2]:

* **Readable** text for humans (non detracting markup)
* **Easy** minimal formatting instructions
* **Portable** cross-platform documents, editable in any text-capable application
* **Flexible** selection of output formats including HTML and PDF
* Standardization: RFC7763/7764, [CommonMark](https://commonmark.org/) 


Use [Pandoc][3] to generate HTML pages from Markdown with `pandoc-html-article`. Include a table of content and section numbering with `pandoc-html-book`. Both Shell aliases use Pandoc templates to generate HTML pages including a [style sheet][5] describing document presentation: 

→ [var/lib/pandoc/html-article.template](../var/lib/pandoc/html-article.template)  
→ [var/lib/pandoc/html-book.template](../var/lib/pandoc/html-book.template)  
→ [var/lib/pandoc/light.css](../var/lib/pandoc/light.css)
→ [var/aliases/pandoc.sh](../var/aliases/pandoc.sh)

For example to generate an HTML page from a document in this directory:

    » sudo apt install pandoc 
    » source ../source_me.sh
    » pandoc-html-book libvirt.md > libvirt.html

1. Install the `pandoc` package on [Debian][6] (cf. [Installing Pandoc][4]).
2. Load the `pandoc-html-*` aliases into your shell environment with → [source_me.sh][10].
3. Generate an HTML page from a Markdown file.

[1]: https://en.m.wikipedia.org/wiki/Markdown
[2]: https://help.github.com/categories/writing-on-github/
[3]: https://de.wikipedia.org/wiki/Pandoc 
[4]: http://pandoc.org/installing.html
[5]: https://en.wikipedia.org/wiki/Cascading_Style_Sheets
[6]: https://www.debian.org/
[10]: ../source_me.sh
[11]: https://github.com/ttscoff/mdless
