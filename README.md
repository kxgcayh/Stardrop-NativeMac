# Junimod

A native macOS mod manager for Stardew Valley, built with Swift and SwiftUI. Previously published as **Stardrop - Native MacOS**, Junimod is an independently maintained fork of [Stardrop](https://github.com/Floogen/Stardrop).

[Download on Nexus Mods](https://www.nexusmods.com/stardewvalley/mods/53356) · [Source code](https://github.com/kxgcayh/Stardrop-NativeMac)

## Requirements

- macOS 14 (Sonoma) or newer.
- Stardew Valley and [SMAPI](https://smapi.io/) installed.
- Apple Silicon or Intel Mac.

## Features

- Install mod archives or folders through drag and drop or `⌘O`.
- Manage profiles, separators, and enabled mods.
- Select multiple mods, reorder them, and toggle them with Space.
- Check for mod updates through SMAPI.
- Connect a Nexus Mods account for downloads, collections, and endorsements. Direct batch downloads require Nexus Premium; free accounts use manual downloads.
- Edit mod configuration files and launch the game with SMAPI.
- Warn about dependencies before deleting mods and protect bundled SMAPI components.

## Install

Download the app from Nexus Mods. Open the disk image and drag **Junimod.app** into Applications. For ZIP downloads, extract the archive first.

Junimod is not notarized with an Apple Developer certificate. macOS may require approval in System Settings → Privacy & Security on first launch.

The Nexus listing and older downloads may still use the Stardrop name. Junimod uses a separate application identity; remove the older application manually if you no longer need it.

## Build

Install Xcode Command Line Tools and use Swift 5.9 or newer:

```sh
swift build
swift run Junimod
```

Create a universal application bundle for Apple Silicon and Intel:

```sh
./build-mac-app.sh
```

Output: `build/Junimod.app`. The bundle is signed locally, without notarization.

Create a disk image:

```sh
./build-dmg.sh
./build-dmg.sh --skip-build
```

Outputs: `build/Junimod-<version>-macOS.dmg`, `build/Junimod.dmg`, and a SHA-256 checksum. Finder layout customization may require automation permission; headless builds skip that styling.

GitHub Actions builds the universal app and uploads a ZIP artifact. Version tags (`v*`) also publish that ZIP as a GitHub release. Nexus uploads remain manual.

## Existing settings and profiles

Junimod deliberately keeps the existing data directory:

```text
~/Library/Application Support/Stardrop/Data/
├── Settings.json
├── Profiles/
├── Separators/
├── Selected Mods/
├── Cache/
├── Collections/
└── Logs/
    └── junimod.log
```

No data migration is needed for existing native Mac users. Settings and profile files retain the Stardrop format. Back up this directory before switching between independently maintained app versions; avoid running both against the same data at once. Previous logs remain in `Logs/stardrop_mac.log`.

## Project layout

- `Sources/Junimod/`: SwiftUI application, models, and services.
- `Assets/Junimod.icns`: inherited Stardrop icon, retained with attribution.
- `Package.swift`: Swift package; no external package dependencies.
- `build-mac-app.sh` and `build-dmg.sh`: macOS packaging.

## Credits and license

Junimod is maintained by [kxgcayh](https://github.com/kxgcayh). The original Stardrop project and inherited icon are credited to [Floogen / PeacefulEnd and contributors](https://github.com/Floogen/Stardrop). Stardew Valley is created by ConcernedApe; SMAPI is maintained by Pathoschild and contributors.

Distributed under the [GNU General Public License v3.0](LICENSE). The C# / Avalonia application is no longer included in this repository; its history and the upstream project remain available.

See [CONTRIBUTING.md](CONTRIBUTING.md) for bug reports and development notes.
