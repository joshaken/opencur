import OSLog

extension Logger {
    private static let subsystem = "io.github.joshaken.opencur"

    static let general = Logger(subsystem: subsystem, category: "general")
    static let finder = Logger(subsystem: subsystem, category: "finder")
    static let terminal = Logger(subsystem: subsystem, category: "terminal")
}
