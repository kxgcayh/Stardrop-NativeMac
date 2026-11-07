import Foundation
import Combine

public final class SMAPILauncherService: ObservableObject {
    public static let shared = SMAPILauncherService()

    @Published public private(set) var isRunning: Bool = false
    @Published public var launchError: String?

    private var activeProcess: Process?

    public func launch(
        mods: [Mod],
        gameDirectory: URL,
        smapiExecutable: URL?
    ) {
        guard !isRunning else { return }

        let pathing = PathingService.shared
        pathing.ensureDirectoriesExist()

        let selectedModsURL = pathing.selectedModsURL
        let fileManager = FileManager.default

        // 1. Clear previous symlinks in Selected Mods
        if let existing = try? fileManager.contentsOfDirectory(at: selectedModsURL, includingPropertiesForKeys: nil) {
            for item in existing {
                try? fileManager.removeItem(at: item)
            }
        }

        // 2. Link enabled mods into Selected Mods
        let enabledMods = mods.filter { $0.isEnabled }
        var usedNames = Set<String>()

        for mod in enabledMods {
            var folderName = mod.directoryURL.lastPathComponent
            if usedNames.contains(folderName.lowercased()) {
                folderName = "\(folderName)_\(mod.id)"
            }
            usedNames.insert(folderName.lowercased())

            let destination = selectedModsURL.appendingPathComponent(folderName)
            try? fileManager.createSymbolicLink(at: destination, withDestinationURL: mod.directoryURL)
        }

        // 3. Resolve executable
        guard let executable = smapiExecutable ?? pathing.resolveSmapiExecutable(gameDirectory: gameDirectory) else {
            let msg = "Could not locate StardewModdingAPI executable at \(gameDirectory.path)"
            DispatchQueue.main.async {
                self.launchError = msg
            }
            ActionLogger.shared.logError(msg)
            return
        }

        // 4. Launch process
        let process = Process()
        process.executableURL = executable
        process.currentDirectoryURL = gameDirectory

        var environment = ProcessInfo.processInfo.environment
        environment["SMAPI_MODS_PATH"] = selectedModsURL.path
        process.environment = environment

        process.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async {
                self?.isRunning = false
                self?.activeProcess = nil
            }
        }

        do {
            try process.run()
            DispatchQueue.main.async {
                self.activeProcess = process
                self.isRunning = true
                self.launchError = nil
            }
        } catch {
            let description = Self.describelaunchError(error, executable: executable)
            ActionLogger.shared.logError("SMAPI launch failed", error: error)
            DispatchQueue.main.async {
                self.launchError = description
                self.isRunning = false
            }
        }
    }

    // MARK: - Error Helpers

    private static func describelaunchError(_ error: Error, executable: URL) -> String {
        let nsError = error as NSError
        // EBADARCH (86) — executable built for a different CPU architecture.
        // On Apple Silicon this typically means the SMAPI binary is x86_64
        // and Rosetta 2 is not installed.
        if nsError.domain == NSPOSIXErrorDomain && nsError.code == Int(EBADARCH) {
            return """
            SMAPI could not be launched because its executable is built for a different CPU \
            architecture than the one your Mac is running.

            If you are on an Apple Silicon Mac (M1/M2/M3/M4), Stardew Valley and SMAPI ship \
            as Intel (x86_64) binaries and require Rosetta 2 to run.

            To install Rosetta 2, open Terminal and run:
                softwareupdate --install-rosetta

            Then try launching SMAPI again.

            Executable: \(executable.path)
            """
        }
        return "Failed to start SMAPI: \(error.localizedDescription)\n\nExecutable: \(executable.path)"
    }

    public func stop() {
        activeProcess?.terminate()
    }
}
