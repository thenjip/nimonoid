import equatable

import std/[sugar]



type
  Verdict*[T: Equatable] = tuple
    ## Represents the 2 sides of an equation after computation.
    actual: T
    expected: T



# TODO: `{.curry.}` pragma does not work for some reason.
proc verdict*[T](actual: T): (expected: T) -> Verdict[T] =
  (expected: T) => (actual, expected)


proc isVerified*[T](self: Verdict[T]): bool =
  self.actual == self.expected
