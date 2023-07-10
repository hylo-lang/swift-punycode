# Swift Punycode

**Swift Punycode** is a Swift implementation of the Punycode encoding, as described in RFC 3492.

 Punycode is a simple and efficient transfer encoding syntax designed to uniquely and reversibly transforms a Unicode string into an ASCII string.
 ASCII characters in the Unicode string are represented literally, and non-ASCII characters are represented by ASCII characters.
 
## Usage

**Swift Punycode** adds two methods to `Swift.String`.

- `String.punycode(delimiter:encodingDigitWith:)` encodes a string into Punycode.
- `String.init?(punycode:delimiter:decodingDigitWith:)` decoes a Punycode string.

For example:

```swift
import Punycode

let greetings = "みなさん、こんにちは!"
let encoded = greetings.punycode()
print(encoded) // Prints "!-63t0lg6d7bk7a1ksic"

let decoded = String(punycode: encoded)!
print(decoded) // Prints "みなさん、こんにちは!"
```

By default, the separator between the literal part and the digits is `"-"`, as specified in RFC 3492.
Further, digits are encoded as single characters in base 36 (e.g., 5 => "5", 11 => "b").

## Installation

To use the **Swift Punycode** in a SwiftPM project,  add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/val-lang/swift-punycode", from: "1.0.0"),
```

Include `"Punycode"` as a dependency for your executable target:

```swift
.target(name: "<target>", dependencies: [
  .product(name: "Punycode", package: "swift-punycode"),
]),
```

Finally, add `import Punycode` to your source code.
