#import "../base-type.typ": base-type, assert-base-type
#import "../ctx.typ": z-ctx
#import "../assertions-util.typ": *
#import "./any.typ": any

/// This function yields a validation schema that is satisfied only by the values given by an array in the 1st positional argument (`list`)
/// 
/// -> schema
#let choice(
  name: "enum",
  default: none,
  assertions: (),
  pre-transform: it=>it,
  post-transform: it=>it,
  list
) = {

  assert-boilerplate-params(
    assertions: assertions,
    pre-transform: pre-transform,
    post-transform: post-transform,
  )

  any() + (
    name: name,
    default: default,
    assertions: (
      (
        precondition: "list",
        condition: (self, it)=>self.list.contains(it),
        message: (self, it)=> "Unknown " + self.name + " `" + it + "`"
      ),
      ..assertions
    ),
    pre-transform: pre-transform,
    post-transform: post-transform,
    list: list,
  )

}

/// Specialization of @@choice that is satisfied only by valid paper sizes as of Typst 0.11
#let papersize = choice.with(name: "paper size", ("a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "iso-b1", "iso-b2", "iso-b3", "iso-b4", "iso-b5", "iso-b6", "iso-b7", "iso-b8", "iso-c3", "iso-c4", "iso-c5", "iso-c6", "iso-c7", "iso-c8", "din-d3", "din-d4", "din-d5", "din-d6", "din-d7", "din-d8", "sis-g5", "sis-e5", "ansi-a", "ansi-b", "ansi-c", "ansi-d", "ansi-e", "arch-a", "arch-b", "arch-c", "arch-d", "arch-e1", "arch-e", "jis-b0", "jis-b1", "jis-b2", "jis-b3", "jis-b4", "jis-b5", "jis-b6", "jis-b7", "jis-b8", "jis-b9", "jis-b10", "jis-b11", "sac-d0", "sac-d1", "sac-d2", "sac-d3", "sac-d4", "sac-d5", "sac-d6", "iso-id-1", "iso-id-2", "iso-id-3", "asia-f4", "jp-shiroku-ban-4", "jp-shiroku-ban-5", "jp-shiroku-ban-6", "jp-kiku-4", "jp-kiku-5", "jp-business-card", "cn-business-card", "eu-business-card", "fr-tellière", "fr-couronne-écriture", "fr-couronne-édition", "fr-raisin", "fr-carré", "fr-jésus", "uk-brief", "uk-draft", "uk-foolscap", "uk-quarto", "uk-crown", "uk-book-a", "uk-book-b", "us-letter", "us-legal", "us-tabloid", "us-executive", "us-foolscap-folio", "us-statement", "us-ledger", "us-oficio", "us-gov-letter", "us-gov-legal", "us-business-card", "us-digest", "us-trade", "newspaper-compact", "newspaper-berliner", "newspaper-broadsheet", "presentation-16-9", "presentation-4-3"))