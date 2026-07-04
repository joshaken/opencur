import Cocoa
import OSLog

@main
@MainActor
enum App {
    static func main() async {
        let logger = Logger.opencur
        logger.info("opencur started")

        do {
            let directory = try FinderService().targetDirectory()
            logger.info("Target directory: \(directory.path)")

            try await preferredTerminal.open(directory: directory)
            logger.info("Successfully opened in \(preferredTerminal.displayName)")
        } catch FinderError.appleEventsPermissionDenied {
            let msg = "Permission denied. Go to System Settings → Privacy & Security → Automation → OpenCur → Finder"
            logger.error("\(msg, privacy: .public)")
        } catch let error as FinderError {
            logger.error("\(error.description, privacy: .public)")
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
}
