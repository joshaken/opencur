import Cocoa

struct TerminalAppLauncher {
    func open(directory: URL) async throws {
        let bundleID = TerminalKind.terminal.bundleIdentifier
        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) else {
            throw TerminalError.notInstalled(TerminalKind.terminal.displayName)
        }

        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = true

        try await NSWorkspace.shared.open([directory], withApplicationAt: appURL, configuration: configuration)
    }
}
