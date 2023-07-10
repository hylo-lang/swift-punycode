extension String {

  /// Returns the Punycode encoding of `self`, computed with the algorithm specified in  RFC 3492.
  ///
  /// Digits are encoded in base 36 (e.g., 5 => "5", 11 => "b").
  ///
  /// - Parameters:
  ///   - delimiter: The delimiter separating the literal from the digits.
  public func punycode(delimiter: Character = "-") -> String {
    punycode(delimiter: delimiter) { (digit) in
      let v = (digit < 26) ? (digit + 97) : (digit + 22)
      return Unicode.Scalar(v)!
    }
  }

  /// Returns the Punycode encoding of `self`, computed with the algorithm specified in  RFC 3492.
  ///
  /// - Parameters:
  ///   - delimiter: The delimiter separating the literal from the digits.
  ///   - encodeDigit: A function that encodes a digit in the range `0 ..< 36` into a the unicode
  ///     scalar value of a character other than `delimiter`.
  public func punycode(
    delimiter: Character = "-",
    encodingDigitWith encodeDigit: (UInt32) -> Unicode.Scalar
  ) -> String {
    String.encode(self, delimiter: delimiter, encodingDigitsWith: encodeDigit)
  }

  /// Creates a string from its given Punycode encoding or returns `nil` if `input` is not a valid
  /// Punycode string.
  ///
  /// Digits are assumed to be encoded in base 36 (e.g., 5 => "5", 11 => "b").
  ///
  /// - Parameters:
  ///   - delimiter: The delimiter separating the literal from the digits.
  public init?(punycode input: String, delimiter: Character = "-") {
    self.init(punycode: input, delimiter: delimiter) { (digit) in
      if digit.value < 58 {
        return digit.value - 22
      } else if digit.value < 123 {
        return digit.value - 97
      } else {
        return nil
      }
    }
  }

  /// Creates a string from its given Punycode encoding or returns `nil` if `input` is not a valid
  /// Punycode string.
  ///
  /// - Parameters:
  ///   - delimiter: The delimiter separating the literal from the digits.
  ///   - decodeDigit: A function that returns the integer value in range `0 ..< 36` represented by
  ///     the unicode scalar value, or `nil` if that scalar doesn't represent any value.
  public init?(
    punycode input: String, delimiter: Character = "-",
    decodingDigitWith decodeDigit: (Unicode.Scalar) -> UInt32?
  ) {
    if let s = String.decode(input, delimiter: delimiter, decodingDigitWith: decodeDigit) {
      self = s
    } else {
      return nil
    }
  }

  // MARK: Bootstring parameter values

  private static let base: UInt32 = 36
  private static let tmin: UInt32 = 1
  private static let tmax: UInt32 = 26
  private static let skew: UInt32 = 38
  private static let damp: UInt32 = 700
  private static let initialBias: UInt32 = 72
  private static let initialN: UInt32 = 0x80

  // MARK: Encoding

  /// Returns the Punycode encoding of `input`, computed with the algorithm specified in  RFC 3492.
  ///
  /// - Parameters:
  ///   - delimiter: The delimiter separating the literal from the digits.
  ///   - encodeDigit: A function that encodes a digit in the range `0 ..< 36` into a the unicode
  ///     scalar value of a character other than `delimiter`.
  private static func encode(
    _ input: String,
    delimiter: Character = "-",
    encodingDigitsWith encodeDigit: (UInt32) -> Unicode.Scalar
  ) -> String {
    var result = ""

    for c in input where c.isASCII {
      result.append(c)
    }

    let codePoints = input.unicodeScalars
    var delta: UInt32 = 0
    var bias = initialBias
    var n = initialN
    let b = UInt32(result.count)
    var h = UInt32(result.count)

    if b > 0 {
      result.append(delimiter)
    }

    while h < codePoints.count {
      var m = UInt32.max
      for p in codePoints {
        if (p.value >= n) && (p.value < m) {
          m = p.value
        }
      }

      precondition((m - n) <= ((UInt32.max - delta) / (h + 1)), "overflow")
      delta += (m - n) * (h + 1)
      n = m

      for p in codePoints {
        if p.value < n {
          precondition(delta != UInt32.max, "overflow")
          delta += 1
        }

        if p.value == n {
          var q = delta
          for k in strides(from: base, by: Int(base)) {
            let t = (k <= bias) ? tmin : (k >= bias + tmax ? tmax : k - bias)
            if (q < t) {
              break
            }
            result.append(String(encodeDigit(t + (q - t) % (base - t))))
            q = (q - t) / (base - t)
          }

          result.append(String(encodeDigit(q)))
          bias = adapt(delta: delta, numPoints: h + 1, firstTime: h == b)
          delta = 0
          h += 1
        }
      }

      delta += 1
      n += 1
    }

    return result
  }

  // MARK: Decoding

  /// Returns the string decoded from the given Punycode `input` or `nil` if `input` is invalid.
  ///
  /// - Parameters:
  ///   - delimiter: The delimiter separating the literal from the digits.
  ///   - decodeDigit: A function that returns the integer value in range `0 ..< 36` represented by
  ///     the unicode scalar value, or `nil` if that scalar doesn't represent any value.
  private static func decode(
    _ input: String, delimiter: Character = "-",
    decodingDigitWith decodeDigit: (Unicode.Scalar) -> UInt32?
  ) -> String? {
    let codePoints = input.unicodeScalars
    var result: [Unicode.Scalar] = []
    var h = codePoints.startIndex

    if let d = input.lastIndex(of: delimiter) {
      result = input.prefix(upTo: d).map(\.unicodeScalars.first!)
      h = codePoints.index(h, offsetBy: result.count + 1)
    }

    var bias = initialBias
    var i: UInt32 = 0
    var n = initialN

    while h < codePoints.endIndex {
      let oldI = i
      var w: UInt32 = 1

      for k in strides(from: base, by: Int(base)) {
        precondition(h < codePoints.endIndex, "bad input")

        let digit = decodeDigit(codePoints[h]) ?? base
        precondition(digit <= (UInt32.max - i) / w, "overflow")
        h = codePoints.index(after: h)
        i += digit * w

        let t = (k <= bias) ? tmin : (k >= bias + tmax ? tmax : k - bias)
        if (digit < t) {
          break
        }

        precondition(w <= UInt32.max / (base - t), "overflow")
        w *= base - t
      }

      bias = adapt(delta: i - oldI, numPoints: UInt32(result.count + 1), firstTime: oldI == 0)

      precondition(i / UInt32(result.count + 1) <= UInt32.max - n, "overflow")
      n += i / UInt32(result.count + 1)
      i %= UInt32(result.count + 1)

      let j = result.index(result.startIndex, offsetBy: Int(i))
      result.insert(Unicode.Scalar(n)!, at: j)
      i += 1
    }

    return result.reduce(into: "", { (s, p) in s.append(contentsOf: String(p)) })
  }

  // MARK: Helpers

  private static func adapt(delta: UInt32, numPoints: UInt32, firstTime: Bool) -> UInt32 {
    var k: UInt32 = 0
    var d = firstTime ? (delta / damp) : (delta >> 1)
    d += d / numPoints
    while d > ((base - tmin) * tmax) / 2 {
      d /= base - tmin
      k += base
    }
    return k + (((base - tmin + 1) * d) / (d + skew))
  }

}
