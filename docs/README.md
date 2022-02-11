# Notes

Write detailed notes to collect knowledge and understanding:

* Think of **writing equals learning**...
* **Work through confusion** structuring details and technical jargon
* **Learn with intention** growing a personal knowledge base
* Collect **distilled knowledge** extracted from your sources
* Permanent, easily **recoverable store of personalized knowledge**

Allows you to create slides, and articles with less effort.

---

## Plain Text

**What is [plain text][plx]?**

* Loose term for content represented with **readable characters only**
* May include a **limited** number of characters for **text arrangement**
* Text considered "plain" as long as it is **[human-readable][hr]**

**Why use plain text?**

* Any computer can read plain text, **no proprietary software** required
* **Compatible with everything**: devices (mobile, PC), editors, applications
* **Sustainable over time**, plain text documents universally processable
* Enforces **simple organization** (accessibility) with files and directories
* Favors content with **simple text structres** like headings, paragraphs, lists
* **Prevents distraction** from tools like modern [WYSIWIG][wy] word processors
* **Fast & productive** by focusing on the content
* Enables **powerful text processing tools** available on the command-line

[Why using plain text email!](https://useplaintext.email/)

[plx]: https://en.wikipedia.org/wiki/Plain_text
[hr]: https://en.m.wikipedia.org/wiki/Human-readable_medium
[wy]: https://en.wikipedia.org/wiki/WYSIWYG
[cu]: https://www.gnu.org/software/coreutils/manual/coreutils.html

There's no such thing as Plain Text, Dylan Beattie  
<https://www.youtube.com/watch?v=oYd2KkuZLbE>

---

## Human technology: Text files

> It is a well-known engineering principle, that you should always use the
> weakest technology capable of solving your problem - the weakest technology
> is likely the cheapest, easiest to maintain, extend or replace and there are
> no sane arguments for using anything else.

> The main problem with this principle is marketing - few people would sell you
> a 10$ product that can solve your problem for ever, when they can sell you a
> 1000$ product, with 10$ per month maintenance cost, that will become obsolete
> after 10 years. If you listen to the “experts” you would likely end up not
> with the simplest, but with the most advanced technology.

> And with software the situation is particularly bad, because the simplest
> technologies often cost zero, and so they have zero marketing budget. And
> since nobody would be benefiting from convincing you to use something that
> does not cost anything, nobody is actively selling those. In this post, I
> will try to fill that gap by reviewing some technologies for web publishing
> that are based on plain text and putting forward their benefits. Read on to
> understand why and how you should write everything you write in plain text
> files and self-publish them on your own website.

[aon]: https://boris-marinov.github.io/text/

---

## Example:  Todo List

[Todo.txt][tx] is a task list format in plain text:

```
[(<priority>)] [<date>] [<due>] [@<context> ...] [+<project> ...] <description>
```

Field       | Description
------------|------------------------------
description | task description
priority    | (optional) upper case character enclosed in parentheses
date        | (optional) task creation date in the format `YYYY-MM-DD`
context     | (optional) context preceded by an @, project preceded by a + 
due         | (optional) due date for the task in the format `due:YYYY-MM-DD`

```
(A) Call Mom @Phone +Family
(A) Schedule annual checkup +Health
(B) Outline chapter 5 +Novel @Computer
(C) Add cover sheets @Office +TPSReports
Plan backyard herb garden @Home
Pick up milk @GroceryStore
Research self-publishing services +Novel @Computer
x Download Todo.txt mobile app @Phone
```

[tx]: http://todotxt.org/ 

---

## Markdown [Documents][dc]

Why use [Markdown][md] for plain text formating?

* **Readable** text for humans (non distracting markup)
* **Easy** minimal formatting instructions
* **Portable** cross-platform documents, editable with text-capable application
* **Flexible** selection of output formats including HTML, PDF, LateX, etc.
* Standardization: RFC7763/7764, [CommonMark][cm]

**Alternatives are [ASCIIdoc][ad] or [Textile][tl]**

Conversion to other formats:

- [Pandoc](https://github.com/jgm/pandoc)  a universal document converter
- [MarkText](https://github.com/marktext/marktext), [PanWriter](https://panwriter.com)
- [GitHub Flavored Markdown](https://github.github.com/gfm/),
  [GitLab Markdown](https://docs.gitlab.com/ee/user/markdown.html)

Ecosystem for authoring documents:

Tool                | Description
--------------------|--------------------------------
[Jupyter Book][jp]  | Books, articles [Jupyter Notebooks](https://jupyter.org/)
[Livemark][lm]      | Books, blogs (background from data journalism)
[R Markdown][rm]    | Books, articles, slides, blogs (originated from the R community)
[MkDocs][mk]        | Software Documentation
[ReadTheDocs][rdoc] | Software documentation

[ad]: https://en.m.wikipedia.org/wiki/AsciiDoc
[cm]: https://commonmark.org/
[dc]: https://en.m.wikipedia.org/wiki/Document
[gm]: https://help.github.com/categories/writing-on-github/
[md]: https://en.m.wikipedia.org/wiki/Markdown
[tl]: https://en.m.wikipedia.org/wiki/Textile_(markup_language)
[jp]: https://jupyterbook.org
[lm]: https://livemark.frictionlessdata.io
[mk]: https://github.com/mkdocs/mkdocs
[rm]: https://github.com/rstudio/rmarkdown-book
[rdoc]: https://github.com/rtfd/readthedocs.org

---

## Presentations

Markdown base **presentation slides**:

- [remark](https://github.com/gnab/remark) (help script ↴ [bin/remark](../bin/remark))
- [reveal](https://github.com/hakimel/reveal.js)
- [cleaver](https://github.com/jdan/cleaver)
- [markdeck](https://github.com/arnehilmann/markdeck)
- [marp](https://github.com/yhatt/marp/)
- [decktape](https://github.com/astefanutti/decktape) PDF exporter for remark
- [md2pdf](https://md2pdf.netlify.com/)

**Highlight the mouse cursor** and **key combinations** with [key-mon](https://github.com/scottkirkwood/key-mon)

Display all **keystrokes as you type** with [screenkey](https://github.com/wavexx/screenkey)

**Screen Annotation** with [gromit-mpx](https://github.com/bk138/gromit-mpx)

* **F9** toggle painting, **Alt-F9** quit
* **Shift-F9** clear screen, **Ctrl-F9** toggle visibility

---

## Presentation Symbols

Use Unicode symbols in presentations (instead of icons/images)

Type           | Symbols
---------------|---------------------------------------
Arrows         | ← → ↑ ↓ ↔ ↕ ⇄ ⇅ ↲ ↳ ↱ ⇤ ↶ ↷ ↺ ↻ ↯ ↖ ➘ ➚ 
Math           | ∞ ± ≤ ≥ ≠ ≈ ÷ × ∅ ∑ 
Sub/Superscript| ⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾ⁿⁱ₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎ₐₑₕᵢⱼₖₗₘₙₒₚᵣₛₜᵤ
Punctuation    | “” »« …
Keys           | ␣ ¶ ↹ ↵ ⏎ · ⏏ ⌥
Common         | ° ✓ ✔ ✗ ✘ ⚠

Cf. [List of Unicode characters](https://en.wikipedia.org/wiki/List_of_Unicode_characters)  
Cf. [Nerd Fonts](https://nerdfonts.com)



[5]: https://en.wikipedia.org/wiki/Cascading_Style_Sheets
[10]: ../source_me.sh
