import SwiftUI

@main
struct JunimodApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        Window("Junimod", id: "main") {
            MainView(state: state)
                .frame(minWidth: 850, minHeight: 500)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .defaultSize(width: 1080, height: 700)
        .handlesExternalEvents(matching: ["*"])
        .commands {
            SidebarCommands()

            CommandGroup(replacing: .newItem) {
                Button("Install Mod Archive...") {
                    NotificationCenter.default.post(name: .installModArchive, object: nil)
                }
                .keyboardShortcut("o", modifiers: .command)
            }

            CommandGroup(replacing: .appInfo) {
                Button("About Junimod") {
                    NotificationCenter.default.post(name: .openAbout, object: nil)
                }
            }

            CommandGroup(replacing: .appSettings) {
                Button("Settings...") {
                    NotificationCenter.default.post(name: .openSettings, object: nil)
                }
                .keyboardShortcut(",", modifiers: .command)
            }

            CommandMenu("Game") {
                Button("Launch SMAPI") {
                    NotificationCenter.default.post(name: .launchSmapi, object: nil)
                }
                .keyboardShortcut("r", modifiers: .command)
            }

            CommandMenu("Nexus Mods") {
                Button("Nexus Mods Account...") {
                    NotificationCenter.default.post(name: .openNexus, object: nil)
                }
                .keyboardShortcut("n", modifiers: [.command, .shift])
            }

            CommandMenu("Mods") {
                Button("Toggle Selected Mod") {
                    NotificationCenter.default.post(name: .toggleSelectedMod, object: nil)
                }
                .keyboardShortcut(.space, modifiers: [])

                Divider()

                Button("New Separator...") {
                    NotificationCenter.default.post(name: .newSeparator, object: nil)
                }
                .keyboardShortcut("s", modifiers: [.command, .shift])

                Divider()

                Button("Refresh Mod List") {
                    NotificationCenter.default.post(name: .refreshMods, object: nil)
                }
                .keyboardShortcut("r", modifiers: [.command, .shift])

                Button("Check for Mod Updates") {
                    NotificationCenter.default.post(name: .checkForUpdates, object: nil)
                }
                .keyboardShortcut("u", modifiers: .command)

                Divider()

                Button("Enable All Mods") {
                    NotificationCenter.default.post(name: .enableAllMods, object: nil)
                }
                .keyboardShortcut("e", modifiers: [.command, .shift])

                Button("Disable All Mods") {
                    NotificationCenter.default.post(name: .disableAllMods, object: nil)
                }
                .keyboardShortcut("d", modifiers: [.command, .shift])
            }

            CommandGroup(replacing: .help) {
                Button("Junimod Documentation") {
                    if let url = URL(string: "https://github.com/kxgcayh/Stardrop-NativeMac#readme") {
                        NSWorkspace.shared.open(url)
                    }
                }
                Button("GitHub Repository") {
                    if let url = URL(string: "https://github.com/kxgcayh/Stardrop-NativeMac") {
                        NSWorkspace.shared.open(url)
                    }
                }
                Button("SMAPI.io") {
                    if let url = URL(string: "https://smapi.io/") {
                        NSWorkspace.shared.open(url)
                    }
                }
                Divider()
                Button("About Junimod") {
                    NotificationCenter.default.post(name: .openAbout, object: nil)
                }
            }
        }
    }
}

extension Notification.Name {
    static let openSettings = Notification.Name("JunimodOpenSettings")
    static let launchSmapi = Notification.Name("JunimodLaunchSmapi")
    static let openNexus = Notification.Name("JunimodOpenNexus")
    static let openAbout = Notification.Name("JunimodOpenAbout")
    static let checkForUpdates = Notification.Name("JunimodCheckForUpdates")
    static let refreshMods = Notification.Name("JunimodRefreshMods")
    static let enableAllMods = Notification.Name("JunimodEnableAllMods")
    static let disableAllMods = Notification.Name("JunimodDisableAllMods")
    static let toggleSelectedMod = Notification.Name("JunimodToggleSelectedMod")
    static let newSeparator = Notification.Name("JunimodNewSeparator")
    static let installModArchive = Notification.Name("JunimodInstallModArchive")
}
