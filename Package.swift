// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EcommerceApp",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v12)],
    targets: [
        .executableTarget(
            name: "EcommerceApp",
            dependencies: [],
            path: "EcommerceApp"
        )
    ]
)
