import
  pkg/nimonoid/[laws],
  pkg/nimonoid/monoids/data_structure/linear/[junction]

import pkg/funcynim/[curry, ignore, into, run, unit]

import std/[unittest]



proc main() =
  suite "nimonoid/monoids/data_structure/linear/junction":
    test """"string" should be "Joinable".""":
      proc doTest(T: typedesc[Joinable]) =
        discard


      doTest(string)



    test """"seq[T]" should be "Joinable".""":
      proc doTest(T: typedesc[Joinable]) =
        discard


      doTest(seq[int])
      doTest(seq[ref CatchableError])



    test """"Junction[T]" should verify the monoid laws.""":
      proc doTest[T](spec: AllLawsSpec[T]): Unit =
        let (leftIdentity, rightIdentity, associativity) =
          spec.verify(junction.junction)

        check(leftIdentity.isVerified())
        check(rightIdentity.isVerified())
        check(associativity.isVerified())


      allLawsSpec(leftIdentitySpec("a"))
        .with(rightIdentitySpec("aaabbbc"))
        .run(associativitySpec(" 012")("&&")("()["))
        .into(doTest)
        .ignore()
      allLawsSpec(leftIdentitySpec(@[1, 2]))
        .with(rightIdentitySpec(@[-4, 0, 310]))
        .run(associativitySpec(@[int.low()])(@[-94])(@[57, int.high()]))
        .into(doTest)
        .ignore()



main()
