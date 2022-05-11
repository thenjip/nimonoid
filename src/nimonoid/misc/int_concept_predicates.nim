import pkg/funcynim/[convert, into, partialproc]



func convertAndVerify*[A; B](
  self: A;
  predicate: proc (self: B): bool {.noSideEffect.}
): bool =
  when compiles(self.to(B)):
    self.to(B).into(predicate)
  else:
    false



func contains*[A: SomeInteger](B: typedesc[SomeInteger]; value: A): bool =
  value.convertAndVerify(partial(?:B in (B.low() .. B.high())))


#[
  TODO: Remove `static` qualifier to `dest`.

  `static` is here so that this works on the JS backend at compile-time.

  See https://github.com/nim-lang/Nim/issues/12492 .
]#
func equals*[A: SomeInteger; B: SomeInteger](src: A; dest: static B): bool =
  src.convertAndVerify(partial(?:B == dest))
