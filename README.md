# Typst report template

CADT Internship Report template written in Typst.

## Setup

1. Install the [Typst compiler](https://typst.app/open-source/#download).
2. Install [uv](https://docs.astral.sh/uv/), then run `uv sync`.

Optional:
- [Fira Code](https://github.com/tonsky/FiraCode) — the default monospace/code font; also needed for the `folder`-lang box-drawing figures to render correctly.
- [Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) VS Code extension. 

## Usage

The report is built from two pieces:

### Header (cover pages)
`src/report-header.docx` — fill in project title, logo, names, dates, then
export it as PDF to `out/report-header.pdf`.

> [!note]
> This exists as a separate Word doc because CADT's cover/approval
pages needed a specific Word layout.

### Body (everything else)
Entry point: `src/report.typ`. Chapters live under `src/chapters/`; add,
remove or reorder them by editing the `#include`s in `report.typ`.

### Configuration
`src/config.typ` is the place for
title, fonts, colors, spacing, and heading-numbering format.

**Important:** `config.header-page-count` must match `report-header.docx`'s
page count. `report.typ` derives its leading blank pages from it, and
`build.py` warns if `report-header.pdf`'s actual page count disagrees.

The existing chapters are CADT-specific example content.

## Building

```sh
uv run build            # compile once -> report.pdf
uv run build --watch    # recompile on save
uv run build --strict   # enforce PDF/UA-1 accessibility conformance
uv run build --name X   # output to X.pdf instead of report.pdf
```

## Reuse checklist

- [ ] `src/config.typ` — title, fonts, colors, numbering format, `header-page-count`
- [ ] `src/report-header.docx` — cover/approval content, re-export to `out/report-header.pdf`
- [ ] `src/chapters/*.typ` — replace example content
- [ ] `src/references.bib` — replace citations
- [ ] `pyproject.toml` — project `name`/`description`
