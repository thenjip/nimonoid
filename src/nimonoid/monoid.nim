import misc/[equatable]



type
  Monoid* {.explain.} =
    concept type X ##[
      A `Monoid` is a type with:
        - An operation to combine 2 values.
        - A neutral element for that operation.

      Examples:
        | Type `T` | Operation | Neutral element |
        | --- | --- | --- |
        | Any integer | `+` | `0` |
        | Any integer >= `1` | `*` | `1` |
        | `bool` | `and` | `true` |
        | `bool` | `or` | `false` |
        | Any linear data structure | `&` | An empty `T` |

      The monoidal properties of a type can be verified using the
      [monoid laws](./laws.html).

      Examples of monoid implementation can be found here:
        - The [Unit](./monoids/unit.html) type.
        - [Integer addition](./monoids/integer/addition.html).
        - [Concatenation](./monoids/data_structure/linear/junction.html)
          for linear data structures.
    ]##
      X.neutral() is X
      proc fold(left, right: X): X

  EquatableMonoid* = Monoid and Equatable
