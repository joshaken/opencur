import Foundation

enum LauncherFactory {
    static func launcher(for terminalKind: TerminalKind) -> any TerminalLauncher {
        switch terminalKind {
        case .terminal: TerminalAppLauncher()
        case .iTerm2: ITerm2Launcher()
        case .ghostty: GhosttyLauncher()
        }
    }
}
