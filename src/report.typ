// Place holder for the actual pages,
// the concat.py script will override these 3 pages
// with the real one so that urls won't be misaligned
// Cover
#pagebreak()
// Title Khmer
#pagebreak()
// Title English
#pagebreak()

// Figures formatting
#show figure.where(kind: image): set figure.caption(position: bottom)
#show figure.where(kind: table): set figure.caption(position: top)

#let muted_blue = oklab(60%, -0.02, -0.14);

#show figure.caption: set text(size: 10pt, style: "italic")

#show link: set text(fill: muted_blue)
#show link: underline

#let header-numbering(..number) = {
  let n = number.pos()
  let level = n.len()

  if level == 1 {
    numbering("I.1.1.", ..n)
  } else if level <= 3 {
    numbering("1.1.1.", ..n)
  } else {
    numbering("a.1.", ..n.slice(3))
  }
}

// Intro formatting
#set page(
  numbering: "I",
)

#set text(
  font: ("Times New Roman", "Siemreap"),
  size: 12pt,
)

// Centers intro headers
#set heading()
#show heading: it => {
  set text(size: 16pt)
  pagebreak(weak: true)
  align(center, block(
    below: 2em,
    it.body,
  ))
}

// Body text formatting
#set par(
  justify: true,
  first-line-indent: (amount: 0.5in, all: true),
  leading: 1em, // or 0.75em (leading spacing)
)

#set list(indent: 0.5in, body-indent: 1em)
#set enum(indent: 0.5in, body-indent: 1em)

#include "sections/intro.typ"

#set heading(numbering: header-numbering)
#show heading: it => {
  let f_size = if it.level == 1 { 16pt } else { 14pt }
  if it.level == 1 { pagebreak(weak: true) }

  set text(size: f_size)

  let (align_at, indent_at) = if it.level <= 3 {
    (0cm, 0.5in)
  } else {
    (0.5in, 1in)
  }

  block(
    above: if it.level == 1 { 1em } else { 1.2em },
    below: if it.level == 1 { 2em } else { 1.5em },
    grid(
      columns: (align_at, indent_at - align_at, 1fr),
      column-gutter: 0pt,
      row-gutter: 0.8em,
      [],
      if it.numbering != none {
        counter(heading).display(it.numbering)
      },
      it.body,
    ),
  )
}

#show cite: it => {
  text(fill: muted_blue, super(it))
}

#show ref: it => {
  text(fill: muted_blue, it)
}

#show raw.where(block: false): it => {
  box(
    fill: oklab(97.52%, -0.001, -0.003),
    inset: (x: 3pt),
    outset: (y: 3pt),
    radius: 3pt,
    stroke: 0.5pt + luma(240),
    text(fill: oklab(20%, -0.000, -0.100), it, font: "Fira Code Retina"),
  )
}
#show raw.where(block: true): it => {
  box(
    fill: oklab(97.52%, -0.001, -0.003),
    stroke: 0.5pt + luma(240),
    inset: 10pt,
    radius: 6pt,
    width: 100%,
    it,
  )
}

#set page(
  numbering: "1",
)
#counter(page).update(1)

#include "sections/1_introduction.typ"

#include "sections/2_project_definition.typ"

#include "sections/3_literature.typ"

// #include "sections/4_presentation.typ"

#include "sections/5_project_analysis.typ"

#include "sections/6_detail_concept.typ"

#include "sections/7_implementation.typ"

#include "sections/8_conclusion.typ"

#set heading(numbering: none)
#show heading: it => {
  set text(size: 16pt)
  pagebreak(weak: true)
  align(center, block(
    below: 2em,
    it.body,
  ))
}

= REFERENCES
#bibliography(
  "references.bib",
  style: "ieee",
  title: none,
)

= APPENDICES
