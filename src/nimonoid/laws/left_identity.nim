##[
  This module allows to check whether a type verifies the monoid left identity
  law.

  Given a type `X` and an instance `x` of this type, the monoid
  left identity law is the following: `X.neutral().fold(x) == x`

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
          pkg/nimonoid/laws/[left_identity],
          std/[unittest]

        suite "somemonoid":
          test "SomeMonoid should verify the monoid left identity law.":
            proc doTest(spec: LeftIdentitySpec[SomeMonoid]) =
              let verdict = spec.verify()

              check(verdict.isVerified())

            doTest(leftIdentitySpec("abc1"))
]##



import
  ../monoid,
  ../misc/[verdict],

  pkg/funcynim/[into],

  std/[sugar]



type
  LeftIdentitySpec*[T] = tuple
    ##[
      Represents the inputs of the monoid's left identity law:
        `T.neutral().fold(expected) == expected`
    ]##
    expected: T



proc leftIdentitySpec*[T](expected: T): LeftIdentitySpec[T] =
  (expected, )



proc map*[A; B](self: LeftIdentitySpec[A]; f: A -> B): LeftIdentitySpec[B] =
  self.expected.into(f).leftIdentitySpec()



proc verify*[M: EquatableMonoid](self: LeftIdentitySpec[M]): Verdict[M] =
  let expected = self.expected

  verdict(M.neutral().fold(expected))(expected)


proc verify*[T; M](self: LeftIdentitySpec[T]; lift: T -> M):
  Verdict[M] =
  self.map(lift).verify()
