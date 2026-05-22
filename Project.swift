import ProjectDescription

let project = Project(
    name: "QRCodeGenerator",
    targets: [
        .target(
            name: "QRStudio",
            destinations: .macOS,
            product: .app,
            bundleId: "io.tuist.QRStudio",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "QR Code Generator",
                "NSHighResolutionCapable": true,
            ]),
            sources: ["QRCodeGenerator/Sources/**"],
            resources: ["QRCodeGenerator/Resources/**"],
            dependencies: [
                .external(name: "QRCode"),
            ]
        ),
        .target(
            name: "QRStudioTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "io.tuist.QRStudioTests",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .default,
            sources: ["QRCodeGenerator/Tests/**"],
            resources: [],
            dependencies: [.target(name: "QRStudio")]
        ),
    ]
)
