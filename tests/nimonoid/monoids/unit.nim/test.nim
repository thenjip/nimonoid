import
  pkg/nimonoid/[laws],
  pkg/nimonoid/monoids/[unit]

import
  pkg/funcynim/[curry, into]

import std/[sugar, unittest]



proc main() =
  suite "nimonoid/monoids/unit":
    test """"Unit" should verify the monoid laws.""":
      proc doTest(u: Unit) =
        let (leftIdentity, rightIdentity, associativity) =
          allLawsSpec(leftIdentitySpec(u))
            .with(rightIdentitySpec(u))
            #[
              TODO: Replace the line below with funcynim's `run` proc.
                `run` makes the C-like compilation fail for some reason.
                Only Nim >= `1.6.4` is able to compile this.
            ]#
            .into(f => f(associativitySpec(u)(u)(u)))
            .verify()

        check(leftIdentity.isVerified())
        check(rightIdentity.isVerified())
        check(associativity.isVerified())


      doTest(unit())



main()
