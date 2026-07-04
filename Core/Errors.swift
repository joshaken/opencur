import Foundation

enum FinderError: LocalizedError, CustomStringConvertible {
    case finderNotRunning
    case noSelection
    case appleEventsPermissionDenied
    case appleScriptError(code: Int, message: String)

    var errorDescription: String? { description }

    var description: String {
        switch self {
        case .finderNotRunning: "Finder is not running"
        case .noSelection: "No item selected and no Finder window available"
        case .appleEventsPermissionDenied: "OpenCur needs permission to control Finder"
        case .appleScriptError(let code, let message): "AppleScript error (\(code)): \(message)"
        }
    }
}

enum TerminalError: LocalizedError, CustomStringConvertible {
    case notInstalled(String)

    var errorDescription: String? { description }

    var description: String {
        switch self {
        case .notInstalled(let name): "\(name) is not installed on this system"
        }
    }
}
