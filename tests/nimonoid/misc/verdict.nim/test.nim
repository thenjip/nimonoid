import pkg/nimonoid/misc/[verdict]

import pkg/funcynim/[run]

import std/[strutils, unittest]



proc main() =
  suite "nimonoid/misc/verdict":
    test [
      """"self.isVerfified()" should return "true" when "self.actual" is""",
      """equal to "self.expected"."""
    ].join($' '):
      proc doTest[T](value: T) =
        let self = verdict(value).run(value)

        check:
          self.isVerified()


      doTest("")
      doTest(-1)



main()
