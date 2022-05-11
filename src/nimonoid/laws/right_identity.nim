##[
  This module allows to check whether a type verifies the monoid right identity
  law.

  Given a type `X` and an instance `x` of this type, the monoid
  right identity law is the following: `x.fold(X.neutral()) == x`

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
          pkg/nimonoid/laws/[right_identity],
          std/[unittest]

        suite "somemonoid":
          test "SomeMonoid should verify the monoid right identity law.":
            proc doTest(spec: RightIdentitySpec[SomeMonoid]) =
              let verdict = spec.verify()

              check(verdict.isVerified())

            doTest(rightIdentitySpec("abc1"))
]##



import
  ../monoid,
  ../misc/[verdict],

  pkg/funcynim/[into],

  std/[sugar]



type
  RightIdentitySpec*[T] = tuple
    ##[
      Represents the inputs of the monoid's right identity law:
        `expected.fold(T.neutral()) == expected`
    ]##
    expected: T



proc rightIdentitySpec*[T](expected: T): RightIdentitySpec[T] =
  (expected, )



proc map*[A; B](self: RightIdentitySpec[A]; f: A -> B): RightIdentitySpec[B] =
  self.expected.into(f).rightIdentitySpec()



proc verify*[M: EquatableMonoid](self: RightIdentitySpec[M]): Verdict[M] =
  let expected = self.expected

  verdict(expected.fold(M.neutral()))(expected)


proc verify*[T; M](self: RightIdentitySpec[T]; lift: T -> M):
  Verdict[M] =
  self.map(lift).verify()
