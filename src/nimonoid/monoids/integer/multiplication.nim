##[
  This module implements the `Multiplication` monoid for integers.

  | Type `T` | Operation | Neutral element |
  | --- | --- | --- |
  | Any integer >= `1` | `*` | `1` |
]##



import ../../misc/[int_concept_predicates]

import pkg/funcynim/[convert, into]

import std/[sugar]



type
  ValidInteger* {.explain.} = concept type X of SomeInteger ##[
    Represents any integer type eligible for the `Multiplication` monoid.

    The integer type's lower bound must be `1`.
  ]##
    1.equals(X.low())

  Multiplication*[T: ValidInteger] = distinct T



proc multiplication*[T](value: T): Multiplication[T] =
  value.to(Multiplication[T])


proc unbox*[T](self: Multiplication[T]): T =
  self.to(T)



proc `==`*[T](left, right: Multiplication[T]): bool =
  left.unbox() == right.unbox()



proc map*[A; B](self: Multiplication[A]; f: A -> B): Multiplication[B] =
  self.unbox().into(f).multiplication()



proc neutral*[T](X: typedesc[Multiplication[T]]): X =
  1.to(T).multiplication()


proc fold*[T](left, right: Multiplication[T]): Multiplication[T] =
  left.map(l => l.`*`(right.unbox()).to(T))
