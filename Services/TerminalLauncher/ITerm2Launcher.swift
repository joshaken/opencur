import Cocoa
@preconcurrency import OSLog

struct ITerm2Launcher: TerminalLauncher {
    private let logger = Logger.terminal

    func open(directory: URL) async throws {
        guard NSWorkspace.shared.urlForApplication(
            withBundleIdentifier: TerminalKind.iTerm2.bundleIdentifier
        ) != nil else {
            throw TerminalError.notInstalled(TerminalKind.iTerm2.displayName)
        }

        let script = iTerm2Script(for: directory.path)
//        try runOScript(script)

        logger.info("Opened \(directory.path) in iTerm2")
    }

    private func iTerm2Script(for path: String) -> String {
        let escapedPath = path.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        return """
        tell application "iTerm2"
            if running then
                tell current window
                    create tab with default profile
                    tell current session
                        write text "cd \(escapedPath)"
                    end tell
                end tell
            else
                activate
                delay 1
                tell current window
                    tell current session
                        write text "cd \(escapedPath)"
                    end tell
                end tell
            end if
        end tell
        """
    }
}
