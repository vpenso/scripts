

# Plain Text

**Why [Human-readable][hr] Plain Text?**

* Any computer can read plain text, **no proprietary software**
* **Compatible with everything**: devices (mobile, PC), text editors, applications, etc.
* **Sustainable over time**  since plain text documents have always been, and will always be, universally accessible
* Enforces **simple organization** (accessibility) with files and directories
* Favors content with **simple text structres** like headings, paragraphs, lists
* **Prevents distraction** from tools like modern [WYSIWIG][wy] word processors
* **Fast & productive** by focusing on the content
* Enables **powerful text processing tools** available on the command-line (e.g. GNU [coreutils][cu])

[hr]: https://en.m.wikipedia.org/wiki/Human-readable_medium
[wy]: https://en.wikipedia.org/wiki/WYSIWYG
[cu]: https://www.gnu.org/software/coreutils/manual/coreutils.html

## Todo List

[Todo.txt][tx] is a task list format in plain text:

    [(<priority>)] [<date>] [<due>] [@<context> ...] [+<project> ...] <description>  

Fields:

- priority: (optional) upper case character enclosed in parentheses
- date: (optional) task creation date in the format `YYYY-MM-DD`
- context: (optional) context preceded by an @, project preceded by a + 
- description: task description
- due: (optional) due date for the task in the format `due:YYYY-MM-DD`

[tx]: http://todotxt.org/ 

## [Documents][dc]

**Documents in this repository use [Markdown][md]**, specifically [GitHub Flavored Markdown][gm]:

* **Readable** text for humans (non detracting markup)
* **Easy** minimal formatting instructions
* **Portable** cross-platform documents, editable in any text-capable application
* **Flexible** selection of output formats including HTML, PDF, LateX, etc.
* Standardization: RFC7763/7764, [CommonMark][cm]

Alternatives are [ASCIIdoc][ad] or [Textile][tl]

[ad]: https://en.m.wikipedia.org/wiki/AsciiDoc
[cm]: https://commonmark.org/
[dc]: https://en.m.wikipedia.org/wiki/Document
[gm]: https://help.github.com/categories/writing-on-github/
[md]: https://en.m.wikipedia.org/wiki/Markdown
[tl]: https://en.m.wikipedia.org/wiki/Textile_(markup_language)

### Ecosystem

* Document conversion, generation:
  - [pandoc](https://github.com/jgm/pandoc)
  - [mkdocs](https://github.com/mkdocs/mkdocs/)
  - [readthedocs](https://github.com/rtfd/readthedocs.org)
* Presentation slides:
  - [remark](https://github.com/gnab/remark)
  - [reveal](https://github.com/hakimel/reveal.js)
  - [cleaver](https://github.com/jdan/cleaver)
  - [marp](https://github.com/yhatt/marp/)
* Command-line viewer:
  - [mdless](https://github.com/ttscoff/mdless)
  - [mdv](https://github.com/axiros/terminal_markdown_viewer)
  - [mdcut](https://github.com/lunaryorn/mdcat)
* [dillinger](https://github.com/joemccann/dillinger) online editor

## Pandoc

Use [Pandoc][3] to generate HTML pages from Markdown with `pandoc-html-article`. Include a table of content and section numbering with `pandoc-html-book`. Both Shell aliases use Pandoc templates to generate HTML pages including a [style sheet][5] describing document presentation: 

→ [var/lib/pandoc/html-article.template](../var/lib/pandoc/html-article.template)  
→ [var/lib/pandoc/html-book.template](../var/lib/pandoc/html-book.template)  
→ [var/lib/pandoc/light.css](../var/lib/pandoc/light.css)  
→ [var/aliases/pandoc.sh](../var/aliases/pandoc.sh)

For example to generate an HTML page from a document in this directory:


    sudo apt install -y pandoc
    source ../source_me.sh
    pandoc-html-book README.md > README.html

1. Install the `pandoc` package on Debian (cf. [Installing Pandoc][4]).
2. Load the `pandoc-html-*` aliases into your shell environment with → [source_me.sh][10].
3. Generate an HTML page from a Markdown file.

[3]: https://de.wikipedia.org/wiki/Pandoc 
[4]: http://pandoc.org/installing.html
[5]: https://en.wikipedia.org/wiki/Cascading_Style_Sheets
[10]: ../source_me.sh
