##[
  The monoid implementation for the `Unit` type.

  | Type `T` | Operation | Neutral element |
  | --- | --- | --- |
  | `Unit` | Returns the `Unit` value | The single `Unit` value |
]##



import pkg/funcynim/[unit]



export unit



func neutral*(T: typedesc[Unit]): T =
  unit()


func fold*(left, right: Unit): Unit =
  left
