// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Junimod",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "Junimod", targets: ["Junimod"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Junimod",
            dependencies: [],
            path: "Sources/Junimod"
        )
    ]
)
