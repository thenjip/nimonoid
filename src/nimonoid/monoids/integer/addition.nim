##[
  This module implements the `Addition` monoid for integers.

  | Type `T` | Operation | Neutral element |
  | --- | --- | --- |
  | Any integer | `+` | `0` |
]##



import ../../misc/[int_concept_predicates]

import pkg/funcynim/[convert, into]

import std/[sugar]



type
  ValidInteger* {.explain.} = concept type X of SomeInteger ##[
    Represents any integer type eligible for the `Addition` monoid.

    The integer type must include `0` in its range.
  ]##
    0 in X

  Addition*[T: ValidInteger] = distinct T



proc addition*[T](value: T): Addition[T] =
  value.to(Addition[T])


proc unbox*[T](self: Addition[T]): T =
  self.to(T)



proc `==`*[T](left, right: Addition[T]): bool =
  left.unbox() == right.unbox()



proc map*[A; B](self: Addition[A]; f: A -> B): Addition[B] =
  self.unbox().into(f).addition()



proc neutral*[T](X: typedesc[Addition[T]]): X =
  0.to(T).addition()


proc fold*[T](left, right: Addition[T]): Addition[T] =
  left.map(l => l.`+`(right.unbox()).to(T))
