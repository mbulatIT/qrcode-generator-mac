// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "QRCode": .framework,
        ]
    )
#endif

let package = Package(
    name: "QRCodeGenerator",
    dependencies: [
        .package(url: "https://github.com/dagronf/QRCode", from: "28.0.0"),
    ]
)
