import Cocoa
@preconcurrency import OSLog

struct GhosttyLauncher: TerminalLauncher {
    private let logger = Logger.terminal

    func open(directory: URL) async throws {
        guard NSWorkspace.shared.urlForApplication(
            withBundleIdentifier: TerminalKind.ghostty.bundleIdentifier
        ) != nil else {
            throw TerminalError.notInstalled(TerminalKind.ghostty.displayName)
        }

        let escapedPath = directory.path
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")

        let script = """
        tell application "Ghostty"
            set cfg to new surface configuration
            set initial working directory of cfg to "\(escapedPath)"
            new window with configuration cfg
        end tell
        """

        var error: NSDictionary?

        guard let appleScript = NSAppleScript(source: script) else {
            throw TerminalError.launchFailed("Failed to create AppleScript")
        }
        appleScript.executeAndReturnError(&error)

        if let error {
            let message = (error[NSAppleScript.errorMessage] as? String)
                ?? error.description

            throw TerminalError.launchFailed(message)
        }

        logger.info("Opened \(directory.path, privacy: .public) in Ghostty")
    }
}