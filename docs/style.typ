#import "@preview/tidy:0.1.0"
#import tidy.styles.default: *

// Color to highlight function names in
#let fn-color = rgb("#4b69c6")


// Colors for Typst types
#let type-colors = (
  "content": rgb("#a6ebe6"),
  "color": rgb("#a6ebe6"),
  "string": rgb("#d1ffe2"),
  "none": rgb("#ffcbc4"),
  "auto": rgb("#ffcbc4"),
  "boolean": rgb("#ffedc1"),
  "integer": rgb("#e7d9ff"),
  "float": rgb("#e7d9ff"),
  "ratio": rgb("#e7d9ff"),
  "length": rgb("#e7d9ff"),
  "angle": rgb("#e7d9ff"),
  "relative-length": rgb("#e7d9ff"),
  "fraction": rgb("#e7d9ff"),
  "symbol": rgb("#eff0f3"),
  "array": rgb("#eff0f3"),
  "dictionary": rgb("#eff0f3"),
  "arguments": rgb("#eff0f3"),
  "selector": rgb("#eff0f3"),
  "module": rgb("#eff0f3"),
  "stroke": rgb("#eff0f3"),
  "function": rgb("#f9dfff"),

  // custom types
  "schema": rgb("#bda8ed"),
  "context": rgb("#afeda8"),
  "internal": rgb("#ff8c8c")
)

#let get-type-color(type) = type-colors.at(type, default: rgb("#eff0f3"))


#let show-outline(module-doc, style-args: (:)) = {
  let prefix = module-doc.label-prefix
  let items = ()
  for fn in module-doc.functions {
    items.push(link(label(prefix + fn.name + "()"), fn.name + "()"))
  }
  list(..items)
}

// Create beautiful, colored type box
#let show-type(type) = { 
  h(2pt)
  box(outset: 2pt, fill: get-type-color(type), radius: 2pt, raw(type))
  h(2pt)
}



#let show-parameter-list(fn, display-type-function) = {
  pad(x: 10pt, {
    set text(font: "Cascadia Mono", size: 0.85em, weight: 340)
    text(fn.name, fill: fn-color)
    "("
    let inline-args = fn.args.len() < 2
    if not inline-args { "\n  " }
    let items = ()
    for (arg-name, info) in fn.args {
      let types 
      if "types" in info {
        types = ": " + info.types.map(x => display-type-function(x)).join(" ")
      }
      items.push(arg-name + types)
    }
    items.join( if inline-args {", "} else { ",\n  "})
    if not inline-args { "\n" } + ")"
    if fn.return-types != none {
      " -> " 
      fn.return-types.map(x => display-type-function(x)).join(" ")
    }
  })
}



// Create a parameter description block, containing name, type, description and optionally the default value. 
#let show-parameter-block(
  name, types, content, style-args,
  show-default: false, 
  default: none, 
) = block(
  inset: 10pt, fill: luma(98%), width: 100%,
  breakable: style-args.break-param-descriptions,
  [
    // #text(weight: "bold", size: 1.1em, name) 
    #box(heading(level: style-args.first-heading-level + 3, name))
    #h(.5cm) 
    #types.map(x => (style-args.style.show-type)(x)).join([ #text("or",size:.6em) ])
  
    #content
    #if show-default [ #parbreak() Default: #raw(lang: "typc", default) ]
  ]
)
