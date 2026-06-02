
#let under-construction(label) = context {
  // return label // uncomment to remove black and yellow style.

  let p-width = page.width

  align(center)[
    #box(width: 0pt)[
      #align(center)[
        #block(width: p-width)[
          #stack(
            dir: ttb,
            spacing: 0pt,

            image("../media/warning.svg", width: 100%, height: 20pt),

            block(
              width: 100%,
              fill: black,
              inset: 2em,
              align(center)[
                #text(fill: rgb("#E0C600"))[#label]
              ],
            ),

            image("../media/warning.svg", width: 100%, height: 20pt),
          )
        ]
      ]
    ]
  ]
}


#let code-figure(body, caption: none) = figure(
  align(left, body),
  caption: caption,
  kind: image,
  supplement: auto,
)
