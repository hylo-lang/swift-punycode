import Punycode
import XCTest

final class PunycodeTests: XCTestCase {

  func testASCII() {
    let input = "abc012"
    let output = "abc012-"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testArabic() {
    let input =
      "\u{0644}\u{064A}\u{0647}\u{0645}\u{0627}\u{0628}\u{062A}\u{0643}\u{0644}" +
      "\u{0645}\u{0648}\u{0634}\u{0639}\u{0631}\u{0628}\u{064A}\u{061F}"
    let output = "egbpdaj6bu4bxfgehfvwxn"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testChineseSimplified() {
    let input =
      "\u{4ED6}\u{4EEC}\u{4E3A}\u{4EC0}\u{4E48}\u{4E0D}\u{8BF4}\u{4E2D}\u{6587}"
    let output = "ihqwcrb4cv8a8dqg056pqjye"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testChineseTraditional() {
    let input =
      "\u{4ED6}\u{5011}\u{7232}\u{4EC0}\u{9EBD}\u{4E0D}\u{8AAA}\u{4E2D}\u{6587}"
    let output = "ihqwctvzc91f659drss3x8bo0yb"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testCzech() {
    let input =
      "\u{0050}\u{0072}\u{006F}\u{010D}\u{0070}\u{0072}\u{006F}\u{0073}\u{0074}" +
      "\u{011B}\u{006E}\u{0065}\u{006D}\u{006C}\u{0075}\u{0076}\u{00ED}\u{010D}" +
      "\u{0065}\u{0073}\u{006B}\u{0079}"
    let output = "Proprostnemluvesky-uyb24dma41a"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testHebrew() {
    let input =
      "\u{05DC}\u{05DE}\u{05D4}\u{05D4}\u{05DD}\u{05E4}\u{05E9}\u{05D5}\u{05D8}" +
      "\u{05DC}\u{05D0}\u{05DE}\u{05D3}\u{05D1}\u{05E8}\u{05D9}\u{05DD}\u{05E2}" +
      "\u{05D1}\u{05E8}\u{05D9}\u{05EA}"
    let output = "4dbcagdahymbxekheh6e0a7fei0b"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testHindi() {
    let input =
      "\u{092F}\u{0939}\u{0932}\u{094B}\u{0917}\u{0939}\u{093F}\u{0928}\u{094D}" +
      "\u{0926}\u{0940}\u{0915}\u{094D}\u{092F}\u{094B}\u{0902}\u{0928}\u{0939}" +
      "\u{0940}\u{0902}\u{092C}\u{094B}\u{0932}\u{0938}\u{0915}\u{0924}\u{0947}" +
      "\u{0939}\u{0948}\u{0902}"
    let output = "i1baa7eci9glrd9b2ae1bj0hfcgg6iyaf8o0a1dig0cd"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testJapanese() {
    let input =
      "\u{306A}\u{305C}\u{307F}\u{3093}\u{306A}\u{65E5}\u{672C}\u{8A9E}\u{3092}" +
      "\u{8A71}\u{3057}\u{3066}\u{304F}\u{308C}\u{306A}\u{3044}\u{306E}\u{304B}"
    let output = "n8jok5ay5dzabd5bym9f0cm5685rrjetr6pdxa"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testKorean() {
    let input =
      "\u{C138}\u{ACC4}\u{C758}\u{BAA8}\u{B4E0}\u{C0AC}\u{B78C}\u{B4E4}\u{C774}" +
      "\u{D55C}\u{AD6D}\u{C5B4}\u{B97C}\u{C774}\u{D574}\u{D55C}\u{B2E4}\u{BA74}" +
      "\u{C5BC}\u{B9C8}\u{B098}\u{C88B}\u{C744}\u{AE4C}"
    let output = "989aomsvi5e83db1d2a355cv1e0vak1dwrv93d5xbh15a0dt30a5jpsd879ccm6fea98c"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testRussian() {
    let input =
      "\u{043F}\u{043E}\u{0447}\u{0435}\u{043C}\u{0443}\u{0436}\u{0435}\u{043E}" +
      "\u{043D}\u{0438}\u{043D}\u{0435}\u{0433}\u{043E}\u{0432}\u{043E}\u{0440}" +
      "\u{044F}\u{0442}\u{043F}\u{043E}\u{0440}\u{0443}\u{0441}\u{0441}\u{043A}" +
      "\u{0438}"
    let output = "b1abfaaepdrnnbgefbadotcwatmq2g4l"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testSpanish() {
    let input =
      "\u{0050}\u{006F}\u{0072}\u{0071}\u{0075}\u{00E9}\u{006E}\u{006F}\u{0070}" +
      "\u{0075}\u{0065}\u{0064}\u{0065}\u{006E}\u{0073}\u{0069}\u{006D}\u{0070}" +
      "\u{006C}\u{0065}\u{006D}\u{0065}\u{006E}\u{0074}\u{0065}\u{0068}\u{0061}" +
      "\u{0062}\u{006C}\u{0061}\u{0072}\u{0065}\u{006E}\u{0045}\u{0073}\u{0070}" +
      "\u{0061}\u{00F1}\u{006F}\u{006C}"
    let output = "PorqunopuedensimplementehablarenEspaol-fmd56a"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testVietnamese() {
    let input =
      "\u{0054}\u{1EA1}\u{0069}\u{0073}\u{0061}\u{006F}\u{0068}\u{1ECD}\u{006B}" +
      "\u{0068}\u{00F4}\u{006E}\u{0067}\u{0074}\u{0068}\u{1EC3}\u{0063}\u{0068}" +
      "\u{1EC9}\u{006E}\u{00F3}\u{0069}\u{0074}\u{0069}\u{1EBF}\u{006E}\u{0067}" +
      "\u{0056}\u{0069}\u{1EC7}\u{0074}"
    let output = "TisaohkhngthchnitingVit-kjcr8268qyxafd2f1b9g"
    XCTAssertEqual(input.punycode(), output)
    XCTAssertEqual(String(punycode: output), input)
  }

  func testCustomDelimiter() {
    XCTAssertEqual("étoile".punycode(delimiter: "_"), "toile_9ra")
    XCTAssertEqual(String(punycode: "toile_9ra", delimiter: "_"), "étoile")
  }

  func testCustomDigitEncoder() {
    let s = "étoile".punycode { (digit) in
      let v = (digit < 26) ? (digit + 97) : (digit + 39)
      return Unicode.Scalar(v)!
    }
    XCTAssertEqual(s, "toile-Jra")
  }

  func testCustomDigitDecoder() {
    let s = String(punycode: "toile-Jra") { (digit) in
      if digit.value < 91 {
        return digit.value - 39
      } else if digit.value < 123 {
        return digit.value - 97
      } else {
        return nil
      }
    }
    XCTAssertEqual(s, "étoile")
  }

}
