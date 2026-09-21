# XMonsters

XMonsters is an iOS companion for tracking Final Fantasy X Monster Arena captures.

## Development

- Xcode 26 or later
- iOS 26 or later
- Swift 6
- SwiftUI

Open `XMonsters.xcodeproj` and run the `XMonsters` scheme.

The app currently contains the modern application foundation. The legacy `DataModel.swift` file is intentionally excluded from the target and retained temporarily as a reference for the catalogue and saved-progress migration work.

## Project status

The original iOS 8 application shell and its iAd, Fabric, Crashlytics, Flurry, and CocoaPods integrations have been removed. Catalogue, persistence, migration, capture, progression, and detail features will be restored incrementally in reviewable pull requests.
