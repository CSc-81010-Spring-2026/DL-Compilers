# Deep Learning Compilers

Lecture slides for CSc 81010 (Compiler Construction), CUNY Graduate Center, Spring 2026.

## Viewing

Open `dl_compilers.html` in any web browser. The deck uses [Slidy](https://www.w3.org/Talks/Tools/Slidy2/): advance with the arrow keys (or space), or by clicking; press `c` or the "Contents" button for the table of contents. The distributed `dl_compilers.html` is a single self-contained file (images inlined) and works fully offline.

## Building from Source

The slides are written in Pandoc Markdown (`dl_compilers.md`) and built with [Pandoc](https://pandoc.org) (version 2.11 or newer, which bundles both the `slidy` writer and `citeproc`, so no extra installs are needed):

```bash
make                  # build dl_compilers.html (references graphics/)
make self-contained   # single-file HTML with images inlined (for distribution)
```

See the `Makefile` for the exact Pandoc invocation and the other targets.

Source files:

- `dl_compilers.md` — the slide content (edit this)
- `refs.bib` — bibliography, rendered via citeproc
- `header.html` — CSS and JavaScript injected into the document `<head>`
- `graphics/` — figures

The `make deploy` target is for the author's own web host and relies on an ssh alias (`compsci`) defined in `~/.ssh/config`; adopters can ignore it.
