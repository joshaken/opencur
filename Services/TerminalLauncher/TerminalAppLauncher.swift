import Cocoa
@preconcurrency import OSLog

struct TerminalAppLauncher: TerminalLauncher {
    private let logger = Logger.terminal

    func open(directory: URL) async throws {
        let bundleID = TerminalKind.terminal.bundleIdentifier
        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) else {
            throw TerminalError.notInstalled(TerminalKind.terminal.displayName)
        }

        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = true

        do {
            try await NSWorkspace.shared.open([directory], withApplicationAt: appURL, configuration: configuration)
            logger.info("Opened \(directory.path) in Terminal.app")
        } catch {
            throw TerminalError.launchFailed(error.localizedDescription)
        }
    }
}
