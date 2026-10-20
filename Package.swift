// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MyExample",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .target(
            name: "Raylib",
            path: "Sources/Raylib",
            publicHeadersPath: "include" 
        ),
        .executableTarget(
            name: "MyExample",
            dependencies: ["Raylib"],
            linkerSettings: [
                .unsafeFlags([
                    "-L", "libs"
                ]),
                .linkedLibrary("raylib"),
                .linkedFramework("Cocoa"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("IOKit"),
                .linkedFramework("OpenGL")
            ]
        )
    ]
)

