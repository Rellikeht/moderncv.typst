/*
 * Customizations on this template:
 *
 * - headings (h1..h4)
 *
 * - `datebox` function: provides content with stacked year
 * above (big) and month below (tinier)
 *
 * - `daterange` function: two `datebox`es separated by an em dash
 *
 * - `xdot`: function, adds a trailing dot to a string only
 * if it's not already present
 *
 * - `cvgrid`: basic layout function that wraps a grid.
 * Controlled by two parameters `left_column_size` (default: 25%)
 * and `grid_column_gutter` (default: 8pt) which control the
 * left column size and the column gutter respectively.
 *
 * - `cvcol`: used to write in the rightmost column only.
 * Builds on `cvgrid`
 *
 * - `cventry`: used to write a CV entry.
 * Builds on `cvgrid`
 *
 * - `cvlangauge`: used to write a language entry.
 * Builds on `cvgrid`
 *
 * - `skill` and `dots`: borrowed from alta template. Used to
 */
#import "@preview/socialhub-fa:1.0.0": *

#let left_column_size = 25%
#let grid_column_gutter = 8pt

#let main_color = rgb(147, 14, 14)
#let heading_color = main_color
#let job_color = rgb("#737373")

#let project(
  title: "", author: [], phone: "", email: "",
  github: "", gitlab: "", left_column_size: left_column_size,
  grid_column_gutter: grid_column_gutter, main_color: main_color,
  heading_color: heading_color, job_color: job_color, body,
) = {
  set document(author: author, title: title)
  set page(numbering: none)
  set text(
    font: ("Latin Modern Sans", "Inria Sans"), lang: "en", fallback: true,
  )
  show math.equation: set text(weight: 400)

  /*
                    * How headings are used:
                    * - h1: section (colored, prominent, with colored rectangle, spans two columns)
                    * - h2: role (bold)
                    * - h3: place (italic)
                    * - h4: generic heading (normal, colored)
                    */
  show heading.where(level: 1): element => [
    #v(0em)
    #box(
      inset: (right: grid_column_gutter, bottom: 0.1em), rect(
        fill: main_color, width: left_column_size, height: 0.25em,
      ),
    )
    #text(element.body, fill: heading_color, weight: 400)
  ]

  show heading.where(level: 2): element => [
    #text(element.body, size: 0.8em)
  ]

  show heading.where(level: 3): element => [
    #text(
      element.body, size: 1em, weight: 400, style: "italic",
    )
  ]

  show heading.where(level: 4): element => block[#text(
      element.body, size: 1em, weight: 400, fill: heading_color,
    )]

  set list(
    marker: box(
      circle(radius: 0.2em, stroke: heading_color), inset: (top: 0.15em),
    ),
  )

  set enum(numbering: (n) => text(fill: heading_color, [#n.]))

  grid(
    columns: (1fr, 1fr), box[
      // Author information.
      #text([#author], weight: 400, 2.5em)

      #v(-1.2em)

      // Title row.
      #block(text(
        weight: 400, 1.5em, title, style: "italic",
        fill: job_color,
      ))
    ], align(
      right + top,
    )[
      // Contact information
      #set block(below: 0.5em)

      #if github != "" {
        align(top)[
          #box(
            height: 1em, baseline: 20%,
          )[#pad(right: 0.4em)[#image("icons/github.svg")]]
          #link("https://github.com/" + github)[#github]
        ]
      }

      #if gitlab != "" {
        align(
          top,
        )[
          // TODO svg
          #gitlab-info(gitlab, url: "https://gitlab.com/" + gitlab)
        ]
      }

      #if phone != "" {
        align(
          top,
        )[
          #box(
            height: 1em, baseline: 20%,
          )[#pad(right: 0.4em)[#image("icons/phone-solid.svg")]]
          #link("tel:" + phone)[#phone]
        ]
      }

      #if email != "" {
        align(
          top,
        )[
          #box(
            height: 1em, baseline: 20%,
          )[#pad(right: 0.4em)[#image("icons/envelope-regular.svg")]]
          #link("mailto:" + email)
        ]
      }
    ],
  )

  // Main body.
  set par(justify: true, leading: 0.5em)

  body
}

#let datebox(month: "", year: []) = box(
  align(
    center, stack(
      dir: ttb, spacing: 0.4em, text(size: 1em, [#year]), text(size: 0.75em, month),
    ),
  ),
)

#let daterange(
  start: (month: "", year: []), end: (month: "", year: []),
) = box(
  stack(
    dir: ltr, spacing: 0.75em, datebox(month: start.month, year: start.year),
    [--], datebox(month: end.month, year: end.year),
  ),
)

#let cvgrid(..cells) = pad(
  bottom: 0.8em,
)[#grid(
    columns: (left_column_size, auto), row-gutter: 0em, column-gutter: grid_column_gutter,
    ..cells,
  )]

#let cvcol(content) = cvgrid([], content)

#let xdot(s) = {
  if s.ends-with(".") {
    s
  } else {
    s + "."
  }
}

#let cventry(
  description, start: (month: "", year: ""), end: (month: "", year: ""),
  place: "", role: [],
) = cvgrid(align(center, daterange(start: start, end: end)), [
  == #role
  === #if place != "" { xdot(place) } else { place }
], [], description)

#let cvlanguage(language: [], description: [], certificate: []) = cvgrid(
  align(right, language), [#description #h(3em) #text(style: "italic", certificate)],
)

#let dots-amount = 5
#let gray = rgb("#c0c0c0")
#let dots(
  amount: dots-amount, total: dots-amount, color: main_color,
  spacing: 2.2pt,
) = {
  if (amount < 0) {
    panic("amount should be nonnegative integer")
  }
  if (total < 0 or amount > total) {
    panic(
      "total should be nonnegative integer greater than amount",
    )
  }

  let i = 1

  box(circle(radius: 4pt, fill: color))

  while (i < amount){
    h(spacing)
    box(circle(radius: 4pt, fill: color))
    i += 1
  }

  while (i < total){
    h(spacing)
    box(circle(radius: 4pt, fill: gray))
    i += 1
  }
}

#let max_rating = 5
#let skill(name: "", rating: 5, space: 1fr, spacing: 2pt) = {
  if (rating < 0 or rating > max_rating) {
    panic(
      "rating should be between 0 and max_rating inclusively",
    )
  }

  let done = false
  let i = 1

  name

  h(space)

  while (not done){
    let colour = gray

    if (i <= rating) {
      colour = main_color
    }

    box(circle(radius: 4pt, fill: colour))

    if (max_rating == i) {
      done = true
    } else {
      // no spacing on last
      h(spacing)
    }

    i += 1
  }

  [\ ]
}
