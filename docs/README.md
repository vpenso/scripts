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

**Markdown Ecosystem**

* Conversion to other formats: [pandoc](https://github.com/jgm/pandoc), [mkdocs](https://github.com/mkdocs/mkdocs/), [readthedocs](https://github.com/rtfd/readthedocs.org)
* Viewer Markdown in the shell: [glow](https://github.com/charmbracelet/glow), [mdless](https://github.com/ttscoff/mdless), [mdv](https://github.com/axiros/terminal_markdown_viewer), [mdcut](https://github.com/lunaryorn/mdcat)
* Edit Markdown online: [dillinger](https://github.com/joemccann/dillinger)
* [Markor](https://github.com/gsantner/markor) for Android

[ad]: https://en.m.wikipedia.org/wiki/AsciiDoc
[cm]: https://commonmark.org/
[dc]: https://en.m.wikipedia.org/wiki/Document
[gm]: https://help.github.com/categories/writing-on-github/
[md]: https://en.m.wikipedia.org/wiki/Markdown
[tl]: https://en.m.wikipedia.org/wiki/Textile_(markup_language)

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
