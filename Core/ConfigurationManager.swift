import Foundation

enum TerminalKind: String, Sendable {
    case terminal = "com.apple.Terminal"
    case iTerm2 = "com.googlecode.iterm2"
    case ghostty = "com.mitchellh.ghostty"

    var bundleIdentifier: String { rawValue }

    var displayName: String {
        switch self {
        case .terminal: "Terminal"
        case .iTerm2: "iTerm2"
        case .ghostty: "Ghostty"
        }
    }

    func open(directory: URL) async throws {
        switch self {
        case .terminal: try await TerminalAppLauncher().open(directory: directory)
        case .iTerm2: try await ITerm2Launcher().open(directory: directory)
        case .ghostty: try await GhosttyLauncher().open(directory: directory)
        }
    }
}

var preferredTerminal: TerminalKind {
    get { TerminalKind(rawValue: UserDefaults.standard.string(forKey: "opencur-terminal-bundle-id") ?? "") ?? .ghostty }
    set { UserDefaults.standard.set(newValue.rawValue, forKey: "opencur-terminal-bundle-id") }
}
