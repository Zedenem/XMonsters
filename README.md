# XMonsters

XMonsters is an iOS companion for tracking Final Fantasy X Monster Arena captures.

## Development

- Xcode 26 or later
- iOS 26 or later
- Swift 6
- SwiftUI

Open `XMonsters.xcodeproj` and run the `XMonsters` scheme.

The top-level `XMonsters.xcworkspace` was removed along with CocoaPods and is no longer used. If it still appears in an existing checkout, close it in Xcode and move that top-level workspace to Trash; untracked Xcode settings can leave the folder behind after pulling the deletion. Open `XMonsters.xcodeproj` instead. Keep the internal `XMonsters.xcodeproj/project.xcworkspace`, which is Xcode's project metadata.

The app currently contains the modern application foundation plus the catalogue, progression calculations, and local saved-progress migration layer. The tracking UI is still a placeholder. The legacy `DataModel.swift` file is intentionally excluded from the target and retained as a migration reference.

See [catalogue and migration](docs/catalogue-and-migration.md) for the data contract and test coverage, and [roadmap](docs/roadmap.md) for the agreed release scope. Run the `XMonsters` scheme's tests in Xcode 26 on an iOS 26 simulator.

## Project status

The original iOS 8 application shell and its iAd, Fabric, Crashlytics, Flurry, and CocoaPods integrations have been removed. Catalogue, persistence, migration, capture, progression, and detail features will be restored incrementally in reviewable pull requests.
