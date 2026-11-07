import Foundation

public final class ActionLogger {
    public static let shared = ActionLogger()

    private let pathing = PathingService.shared
    private let fileManager = FileManager.default
    private let queue = DispatchQueue(label: "com.kxgcayh.junimod.actionlog")
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f
    }()

    public var logFileURL: URL {
        pathing.logsURL.appendingPathComponent("junimod.log")
    }

    public func log(_ message: String) {
        write(prefix: "INFO ", message: message)
    }

    public func logWarning(_ message: String) {
        write(prefix: "WARN ", message: message)
    }

    public func logError(_ message: String, error: Error? = nil) {
        let full: String
        if let error {
            full = "\(message): \(error.localizedDescription)"
        } else {
            full = message
        }
        write(prefix: "ERROR", message: full)
    }

    // MARK: - Private

    private func write(prefix: String, message: String) {
        let line = "[\(dateFormatter.string(from: Date()))] [\(prefix)] \(message)\n"
        queue.async {
            try? self.fileManager.createDirectory(at: self.pathing.logsURL, withIntermediateDirectories: true)
            let url = self.logFileURL
            if !self.fileManager.fileExists(atPath: url.path) {
                self.fileManager.createFile(atPath: url.path, contents: nil)
            }
            if let handle = try? FileHandle(forWritingTo: url) {
                defer { try? handle.close() }
                _ = try? handle.seekToEnd()
                if let data = line.data(using: .utf8) {
                    try? handle.write(contentsOf: data)
                }
            }
        }
    }
}
