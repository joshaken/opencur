import Foundation

enum FinderError: LocalizedError, CustomStringConvertible {
    case finderNotRunning
    case noFinderWindows
    case noSelection
    case invalidSelection
    case aliasResolutionFailed
    case invalidURL(String)

    var errorDescription: String? {
        description
    }

    var description: String {
        switch self {
        case .finderNotRunning: "Finder is not running"
        case .noFinderWindows: "No Finder windows are open"
        case .noSelection: "No item selected and no Finder window available"
        case .invalidSelection: "The selected Finder item is invalid"
        case .aliasResolutionFailed: "Failed to resolve Finder alias"
        case .invalidURL(let path): "Could not create a valid URL from: \(path)"
        }
    }
}

enum TerminalError: LocalizedError, CustomStringConvertible {
    case notInstalled(String)
    case launchFailed(String)
    case scriptFailed(String)

    var errorDescription: String? {
        description
    }

    var description: String {
        switch self {
        case .notInstalled(let name): "\(name) is not installed on this system"
        case .launchFailed(let detail): "Failed to launch terminal: \(detail)"
        case .scriptFailed(let detail): "Terminal scripting failed: \(detail)"
        }
    }
}

