import Cocoa

struct ITerm2Launcher {
    func open(directory: URL) async throws {
        guard let appURL = NSWorkspace.shared.urlForApplication(
            withBundleIdentifier: TerminalKind.iTerm2.bundleIdentifier
        ) else {
            throw TerminalError.notInstalled(TerminalKind.iTerm2.displayName)
        }

        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = true

        try await NSWorkspace.shared.open([directory], withApplicationAt: appURL, configuration: configuration)
    }
}
