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

        try await NSWorkspace.shared.open([directory], withApplicationAt: appURL, configuration: configuration)

        let script = terminalScript(for: directory.path)
//        try runOScript(script)

        logger.info("Opened \(directory.path) in Terminal.app")
    }

    private func terminalScript(for path: String) -> String {
        let escapedPath = path.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        return """
        tell application "Terminal"
            if (count of windows) is 0 then
                reopen
                activate
            end if
            do script "cd \"\(escapedPath)\""
        end tell
        """
    }
}
