// Shared layout for the tutor guides. Each lesson file imports it.

#let blue = rgb("#1f5fa8")
#let green = rgb("#2e7d4f")
#let amber = rgb("#9a6200")
#let red = rgb("#b03a2e")
#let grey = rgb("#5f6670")

#let callout(label, accent, body) = block(
  width: 100%,
  inset: (x: 10pt, top: 7pt, bottom: 9pt),
  fill: accent.lighten(93%),
  stroke: (left: 2.5pt + accent),
  breakable: false,
  above: 0.9em,
  below: 0.9em,
)[
  #set par(spacing: 0.7em)
  #text(size: 7.5pt, weight: "bold", fill: accent, tracking: 0.06em, upper(label))

  #body
]

#let ask(body) = callout("Ask", blue, body)
#let expect(body) = callout("Expected (for you)", green, body)
#let hints(body) = callout("If stuck, in this order", amber, body)
#let watch(body) = callout("Watch for", red, body)
#let task(body) = callout("Task", grey, body)

#let guide(number: 1, title: "", subtitle: "", meta: (), body) = {
  set document(title: "Lesson " + str(number) + ": " + title)
  set page(
    paper: "a4",
    margin: (x: 2.1cm, top: 2.2cm, bottom: 2.2cm),
    header: context {
      if here().page() > 1 {
        set text(size: 8pt, fill: grey)
        [Lesson #number: #title #h(1fr) My-GPT tutor guide]
      }
    },
    footer: context {
      set text(size: 8pt, fill: grey)
      h(1fr)
      counter(page).display("1 / 1", both: true)
    },
  )
  set text(font: ("Helvetica Neue", "Libertinus Serif"), size: 10pt, lang: "en")
  set smartquote(enabled: false)
  set par(leading: 0.62em, spacing: 1em)
  set list(indent: 0.4em, spacing: 0.65em)
  set enum(indent: 0.4em, spacing: 0.65em)
  set table(
    stroke: 0.5pt + luma(205),
    inset: (x: 6pt, y: 5pt),
    fill: (_, y) => if y == 0 { luma(238) },
  )
  show raw: set text(font: ("Menlo", "DejaVu Sans Mono"), size: 8.5pt)
  show raw.where(block: true): block.with(width: 100%, fill: luma(245), inset: 8pt, radius: 2pt, breakable: false)
  show link: set text(fill: blue)
  show heading.where(level: 1): it => block(
    above: 1.8em,
    below: 0.9em,
    width: 100%,
    inset: (bottom: 4pt),
    stroke: (bottom: 0.6pt + grey),
    text(size: 14pt, weight: "bold", it.body),
  )
  show heading.where(level: 2): it => block(
    above: 1.4em,
    below: 0.8em,
    text(size: 11pt, weight: "bold", fill: blue, it.body),
  )

  text(size: 8pt, weight: "bold", fill: grey, tracking: 0.08em, upper("My-GPT tutor guide"))
  v(0.1em)
  text(size: 22pt, weight: "bold")[Lesson #number: #title]
  v(0.1em)
  text(size: 11pt, fill: grey, subtitle)
  v(0.5em)
  table(
    columns: (auto, 1fr),
    stroke: none,
    fill: none,
    inset: (x: 0pt, y: 4pt),
    column-gutter: 14pt,
    ..meta.map(((label, value)) => (text(weight: "bold", label), value)).flatten(),
  )
  body
}
