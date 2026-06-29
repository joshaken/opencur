import Cocoa
import OSLog

struct FinderService {
    private let logger = Logger.finder

    func targetDirectory() throws -> URL {
        let script = NSAppleScript(source: finderScript)
        var errorInfo: NSDictionary?
        let result = script?.executeAndReturnError(&errorInfo)

        if errorInfo != nil {
            throw FinderError.finderNotRunning
        }

        guard let descriptor = result, descriptor.descriptorType != typeAEList else {
            throw FinderError.noFinderWindows
        }

        guard let path = descriptor.stringValue, !path.isEmpty else {
            throw FinderError.noSelection
        }

        let url = URL(fileURLWithPath: path)
        logger.info("Resolved directory: \(url.path)")
        return url
    }
}

private let finderScript = """
tell application "Finder"
    set sel to selection
    if sel is {} then
        try
            set win to front window
            set target_ to target of win
            try
                set target_ to original item of target_
            end try
            return POSIX path of (target_ as text)
        on error
            return ""
        end try
    else
        set item_ to item 1 of sel
        try
            set item_ to original item of item_
        end try
        set itemPath to POSIX path of (item_ as text)
        if itemPath does not end with "/" then
            try
                set container_ to container of item_
                return POSIX path of (container_ as text)
            on error
                return itemPath
            end try
        end if
        return itemPath
    end if
end tell
"""
