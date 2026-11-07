import Foundation

public final class SettingsService {
    public static let shared = SettingsService()

    private let pathing = PathingService.shared
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()

    public func loadSettings() -> JunimodSettings {
        pathing.ensureDirectoriesExist()

        let file = pathing.settingsURL
        guard let data = try? Data(contentsOf: file),
              let settings = try? jsonDecoder.decode(JunimodSettings.self, from: data) else {
            let def = JunimodSettings()
            saveSettings(def)
            return def
        }
        return settings
    }

    public func saveSettings(_ settings: JunimodSettings) {
        pathing.ensureDirectoriesExist()

        let file = pathing.settingsURL
        do {
            let data = try jsonEncoder.encode(settings)
            try data.write(to: file, options: .atomic)
        } catch {
            ActionLogger.shared.logError("Failed to save settings", error: error)
            print("Failed to save settings: \(error)")
        }
    }
}
