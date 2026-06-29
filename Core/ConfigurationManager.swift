import Foundation

enum TerminalKind: String, CaseIterable, Sendable {
    case terminal = "com.apple.Terminal"
    case iTerm2 = "com.googlecode.iterm2"
    case ghostty = "com.mitchellh.ghostty"

    var displayName: String {
        switch self {
        case .terminal: "Terminal"
        case .iTerm2: "iTerm2"
        case .ghostty: "Ghostty"
        }
    }

    var bundleIdentifier: String { rawValue }
}

final class ConfigurationManager: @unchecked Sendable {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var preferredTerminal: TerminalKind {
        get {
            let raw = defaults.string(forKey: "opencur-terminal-bundle-id")
            return TerminalKind(rawValue: raw ?? "") ?? .ghostty
        }
        set {
            defaults.set(newValue.rawValue, forKey: "opencur-terminal-bundle-id")
        }
    }

    func reset() {
        defaults.removeObject(forKey: "opencur-terminal-bundle-id")
    }
}
