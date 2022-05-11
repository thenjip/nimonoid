##[
  This module implements the `Junction` monoid (a.k.a. `Concatenation`) for
  linear data structures such as `seq[T]`, `string`, or linked lists.

  | Type `T` | Operation | Neutral element |
  | --- | --- | --- |
  | Any linear data structure | `&` | The empty `T` |
]##



import pkg/funcynim/[convert, into]

import std/[sugar]



type
  Joinable* = concept type X
    proc `&`(left, right: X): X

  Junction*[T: Joinable] = distinct T



proc junction*[T](self: T): Junction[T] =
  self.to(Junction[T])


proc unbox*[T](self: Junction[T]): T =
  self.to(T)



proc `==`*[T](left, right: Junction[T]): bool =
  left.unbox() == right.unbox()



proc map*[A; B](self: Junction[A]; f: A -> B): Junction[B] =
  self.unbox().into(f).junction()



proc neutral*(X: typedesc[Junction[string]]): X =
  string.default().junction()


proc neutral*[T](X: typedesc[Junction[seq[T]]]): X =
  seq[T].default().junction()



proc fold*[T](left, right: Junction[T]): Junction[T] =
  left.map(l => l.`&`(right.unbox()).to(T))
