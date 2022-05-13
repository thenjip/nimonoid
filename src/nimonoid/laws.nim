##[
  This module allows to check whether a type verifies the monoid laws, and
  therefore whether this monoid is well defined.

  Given a type `X` and 3 instances `x`, `y` and `z` of this type, the monoid
  laws are the following:

  | Law name | Equation |
  | --- | --- |
  | Left identity | `X.neutral().fold(x) == x` |
  | Right identity | `x.fold(X.neutral()) == x` |
  | Associativity | `x.fold(y).fold(z) == x.fold(y.fold(z))` |

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
          pkg/nimonoid/[laws],
          pkg/funcynim/[curry, run],
          std/[unittest]

        suite "somemonoid":
          test "SomeMonoid should verify the monoid laws.":
            proc doTest(spec: AllLawsSpec[SomeMonoid]) =
              let (leftIdentity, rightIdentity, associativity) = spec.verify()

              check(leftIdentity.isVerified())
              check(rightIdentity.isVerified())
              check(associativity.isVerified())

            allLawsSpec(leftIdentitySpec("abc"))
              .with(rightIdentitySpec("0213 "))
              .run(associativitySpec("jUFh")("pdAb")("5JK0"))
              .doTest()
]##



import monoid
import laws/[associativity, left_identity, right_identity]
import misc/[verdict]

import pkg/funcynim/[curry, run]

import std/[sugar]



export associativity, left_identity, right_identity, verdict



type
  AllLaws*[L; R; A] = tuple
    leftIdentity: L
    rightIdentity: R
    associativity: A

  AllLawsSpec*[T] = ## Represents the input for each monoid law.
    AllLaws[LeftIdentitySpec[T], RightIdentitySpec[T], AssociativitySpec[T]]

  AllLawsVerdict*[T] = AllLaws[Verdict[T], Verdict[T], Verdict[T]]



#[
  TODO:
    `{.curry.}` pragma does not work for some reason.
    Currying would make type inference not work anyway.
]#
proc allLaws*[L; R; A](leftIdentity: L; rightIdentity: R; associativity: A):
  AllLaws[L, R, A] =
  (leftIdentity, rightIdentity, associativity)


proc allLawsSpec*[T](
  leftIdentity: LeftIdentitySpec[T];
  rightIdentity: RightIdentitySpec[T];
  associativity: AssociativitySpec[T]
): AllLawsSpec[T] {.curry.} =
  allLaws(leftIdentity, rightIdentity, associativity)


proc allLawsVerdict*[T](
  leftIdentity: Verdict[T];
  rightIdentity: Verdict[T];
  associativity: Verdict[T]
): AllLawsVerdict[T] {.curry.} =
  allLaws(leftIdentity, rightIdentity, associativity)



proc verify*[M: EquatableMonoid](self: AllLawsSpec[M]): AllLawsVerdict[M] =
  allLawsVerdict(self.leftIdentity.verify())
    .with(self.rightIdentity.verify())
    .run(self.associativity.verify())


proc verify*[T; M](self: AllLawsSpec[T]; lift: T -> M):
  AllLawsVerdict[M] =
  ## Applies `lift` on each input in `self`, before verifying the monoid laws.
  allLawsVerdict(self.leftIdentity.verify(lift))
    .with(self.rightIdentity.verify(lift))
    .run(self.associativity.verify(lift))
