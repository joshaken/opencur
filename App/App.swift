import Cocoa
import OSLog

@main
@MainActor
enum App {
    static func main() async {
        let logger = Logger.general
        logger.info("opencur started")

        do {
            let directory = try FinderService().targetDirectory()
            logger.info("Target directory: \(directory.path)")

            let config = ConfigurationManager()
            let launcher = LauncherFactory.launcher(for: config.preferredTerminal)

            try await launcher.open(directory: directory)
            logger.info("Successfully opened in \(config.preferredTerminal.displayName)")
        } catch let error as FinderError {
            logger.error("Finder error: \(error.description)")
        } catch let error as TerminalError {
            logger.error("Terminal error: \(error.description)")
        } catch {
            logger.error("Unexpected error: \(error.localizedDescription)")
        }
    }
}