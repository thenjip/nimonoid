# nimonoid

[![Build Status](https://github.com/thenjip/nimonoid/workflows/Tests/badge.svg?branch=main)](https://github.com/thenjip/nimonoid/actions?query=workflow%3A"Tests"+branch%3A"main")
[![Licence](https://img.shields.io/github/license/thenjip/nimonoid.svg)](https://raw.githubusercontent.com/thenjip/nimonoid/main/LICENSE)

A monoid library for Nim.

A monoid is a type with an operation to combine 2 values and a neutral element
for this operation.

## Backend compatibility

- C
- C++
- Objective-C
- JavaScript
- NimScript (not tested yet)

## Installation

```sh
nimble install 'https://github.com/thenjip/nimonoid'
```

### Dependencies

- [`nim`](https://nim-lang.org/) >= `1.6.4` & < `2.0.0`
- [`funcynim`](https://github.com/thenjip/funcynim) >= `1.0.0` & < `2.0.0`

## Documentation

- [API](https://thenjip.github.io/nimonoid)

## Features

### API to check the monoid laws for an implementation

- ``somemonoid.nim``

  ```nim
  type SomeMonoid = string

  proc neutral*(X: typedesc[SomeMonoid]): X =
    ""

  proc fold*(left, right: SomeMonoid): SomeMonoid =
    left & right
  ```

- ``test.nim``

  ```nim
  import somemonoid
  import pkg/nimonoid/[laws]
  import pkg/funcynim/[curry, ignore, into, run, unit]
  import std/[unittest]

  suite "somemonoid":
    test "SomeMonoid should verify the monoid laws.":
      proc doTest(spec: AllLawsSpec[SomeMonoid]): Unit =
        let (leftIdentity, rightIdentity, associativity) = spec.verify()

        check(leftIdentity.isVerified())
        check(rightIdentity.isVerified())
        check(associativity.isVerified())

      allLawsSpec(leftIdentitySpec("abc"))
        .with(rightIdentitySpec("0213 "))
        .run(associativitySpec("jUFha")("pdAbhqc")("5JK0jkty"))
        .into(doTest)
        .ignore()
  ```

### Monoid implementations for standard types

- Integers
  - [Addition](./src/nimonoid/monoids/integer/addition.nim)
  - [Multiplication](./src/nimonoid/monoids/integer/multiplication.nim)
- Linear data structures
  - [Concatenation](./src/nimonoid/monoids/data_structure/linear/junction.nim)
- And [more](./src/nimonoid/monoids/).
