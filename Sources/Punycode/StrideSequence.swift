/// A sequence of values offset by a fixed stride.
struct StrideSequence<Element: Strideable>: IteratorProtocol, Sequence {

  /// The next value in the sequence.
  private var start: Element

  /// The distance between two values in the sequence.
  private var stride: Element.Stride

  /// Creates an instance enumerating elements from `start` by strides of `stride`.
  init(from start: Element, by stride: Element.Stride) {
    self.start = start
    self.stride = stride
  }

  mutating func next() -> Element? {
    defer { start = start.advanced(by: stride) }
    return start
  }

}

/// Returns a seuqence enumerating elements from `start` by strides of `stride`.
func strides<S: Strideable>(from start: S, by stride: S.Stride) -> StrideSequence<S> {
  .init(from: start, by: stride)
}
