import Foundation

protocol TerminalLauncher: Sendable {
    func open(directory: URL) async throws
}
