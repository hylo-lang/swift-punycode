// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "swift-punycode",
  products: [
    .library(name: "Punycode", targets: ["Punycode"]),
  ],
  targets: [
    .target(name: "Punycode"),
    .testTarget(name: "PunycodeTests", dependencies: ["Punycode"]),
  ])
