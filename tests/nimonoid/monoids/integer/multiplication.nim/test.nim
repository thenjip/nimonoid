import
  pkg/nimonoid/[laws],
  pkg/nimonoid/monoids/integer/[multiplication]

import pkg/funcynim/[curry, ignore, into, run, unit]

import std/[strutils, unittest]



proc main() =
  suite "nimonoid/monoids/integer/multiplication":
    test """Integer types which lower bound is 1 should be "ValidInteger".""":
      proc doTest(T: typedesc[ValidInteger]) =
        discard


      doTest(Positive)
      doTest(range[1 .. 94])
      doTest(range[1u16 .. 1u16])



    test [
      "Integer types which lower bound is not 1 should not be",
      """"ValidInteger"."""
    ].join($' '):
      proc doTest(T: typedesc[SomeInteger]) =
        static:
          doAssert(T isnot ValidInteger)


      doTest(range[0u16 .. 0u16])
      doTest(range[int8.low() .. -1i8])
      doTest(Natural)



    test """"Multiplication[T]" should verify the monoid laws.""":
      type
        MultUInt = range[1u .. uint.high()]
        MultNatural = range[1.Natural .. Natural.high()]


      proc doTest[T](spec: AllLawsSpec[T]): Unit =
        let (leftIdentity, rightIdentity, associativity) =
          spec.verify(multiplication.multiplication)

        check(leftIdentity.isVerified())
        check(rightIdentity.isVerified())
        check(associativity.isVerified())


      allLawsSpec(leftIdentitySpec(5.MultUInt))
        .with(rightIdentitySpec(11.MultUInt))
        .run(associativitySpec(134.MultUInt)(62)(7))
        .into(doTest)
        .ignore()
      allLawsSpec(leftIdentitySpec(2.MultNatural))
        .with(rightIdentitySpec(7.MultNatural))
        .run(associativitySpec(681.MultNatural)(9)(131))
        .into(doTest)
        .ignore()



main()
