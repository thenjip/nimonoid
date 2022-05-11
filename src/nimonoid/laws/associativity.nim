##[
  This module allows to check whether a type verifies the monoid associativity
  law.

  Given a type `X` and 3 instances `x`, `y` and `z` of this type, the monoid
  associativity law is the following: `x.fold(y).fold(z) == x.fold(y.fold(z))`

  Example usage:
    - ``somemonoid.nim``

      .. code-block:: nim
        type SomeMonoid = string

        proc neutral*(X: typedesc[SomeMonoid]): X =
          ""

        proc fold*(left, right: SomeMonoid): SomeMonoid =
          left & right

    - ``test.nim``

      .. code-block:: nim
        import
          somemonoid,
          pkg/nimonoid/laws/[associativity],
          std/[unittest]

        suite "somemonoid":
          test "SomeMonoid should verify the monoid associativity law.":
            proc doTest(spec: AssociativitySpec[SomeMonoid]) =
              let verdict = spec.verify()

              check(verdict.isVerified())

            doTest(associativitySpec("jUFh")("pdAb")("5JK0"))
]##



import
  ../monoid,
  ../misc/[verdict],

  std/[sequtils, sugar]



type
  AssociativitySpec*[T] = tuple
    ##[
      Represents the inputs of the monoid's associativity law:
        `first.fold(second).fold(third) == first.fold(second.fold(third))`
    ]##
    first: T
    second: T
    third: T



# TODO: `{.curry.}` pragma does not work for some reason.
proc associativitySpec*[T](first: T):
  (second: T) -> ((third: T) -> AssociativitySpec[T]) =
  (second: T) => ((third: T) => (first, second, third))



proc map*[A; B](self: AssociativitySpec[A]; f: A -> B): AssociativitySpec[B] =
  let values = [self.first, self.second, self.third].map(f)

  (values[0], values[1], values[2])



proc verify*[M: EquatableMonoid](self: AssociativitySpec[M]): Verdict[M] =
  let (first, second, third) = self

  verdict(first.fold(second).fold(third))(first.fold(second.fold(third)))


proc verify*[T; M](self: AssociativitySpec[T]; lift: T -> M):
  Verdict[M] =
  self.map(lift).verify()
