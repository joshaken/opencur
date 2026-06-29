import Cocoa
@preconcurrency import OSLog

struct ITerm2Launcher: TerminalLauncher {
    private let logger = Logger.terminal

    func open(directory: URL) async throws {
        let bundleID = TerminalKind.iTerm2.bundleIdentifier
        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) else {
            throw TerminalError.notInstalled(TerminalKind.iTerm2.displayName)
        }

        let script = iTerm2Script(for: directory.path)
        var errorInfo: NSDictionary?
        let appleScript = NSAppleScript(source: script)
        appleScript?.executeAndReturnError(&errorInfo)

        if let errorInfo {
            logger.warning("iTerm2 AppleScript failed, falling back to NSWorkspace: \(errorInfo)")
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.activates = true
            do {
                try await NSWorkspace.shared.open([directory], withApplicationAt: appURL, configuration: configuration)
            } catch {
                throw TerminalError.launchFailed(error.localizedDescription)
            }
        }

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
