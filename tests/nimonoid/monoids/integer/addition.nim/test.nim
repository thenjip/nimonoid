import
  pkg/nimonoid/[laws],
  pkg/nimonoid/monoids/integer/[addition]

import pkg/funcynim/[curry, run]

import std/[strutils, unittest]



proc main() =
  suite "nimonoid/monoids/integer/addition":
    test [
      "Integer types that include 0 in their range should be",
      """"ValidInteger"."""
    ].join($' '):
      proc doTest(T: typedesc[ValidInteger]) =
        discard


      doTest(uint8)
      doTest(uint16)
      doTest(uint32)
      when declared(uint64):
        doTest(uint64)
      doTest(Natural)
      doTest(range[-5i8 .. 12i8])



    test [
      "Integer types that do not include 0 in their range should not be a",
      """"ValidInteger"."""
    ].join($' '):
      proc doTest(T: typedesc[SomeInteger]) =
        static:
          doAssert(T isnot ValidInteger)


      doTest(Positive)
      doTest(range[int8.low() .. -1i8])
      doTest(range[2u16 .. 10u16])



    test """"Addition[T]" should verify the monoid laws.""":
      proc doTest[T](spec: AllLawsSpec[T]) =
        let (leftIdentity, rightIdentity, associativity) =
          spec.verify(addition.addition)

        check(leftIdentity.isVerified())
        check(rightIdentity.isVerified())
        check(associativity.isVerified())


      allLawsSpec(leftIdentitySpec(5))
        .with(rightIdentitySpec(-11))
        .run(associativitySpec(0)(62)(-7))
        .doTest()
      allLawsSpec(leftIdentitySpec(0.Natural))
        .with(rightIdentitySpec(7.Natural))
        .run(associativitySpec(681.Natural)(9)(131))
        .doTest()



main()
