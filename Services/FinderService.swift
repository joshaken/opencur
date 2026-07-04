import Cocoa
import OSLog

@discardableResult
func runOScript(_ script: String) throws -> String {
    let tmp = FileManager.default.temporaryDirectory
        .appendingPathComponent("opencur-\(UUID().uuidString).applescript")
    try script.write(to: tmp, atomically: true, encoding: .utf8)
    defer { try? FileManager.default.removeItem(at: tmp) }

    let task = Process()
    task.launchPath = "/usr/bin/osascript"
    task.arguments = [tmp.path]

    let outputPipe = Pipe()
    let errorPipe = Pipe()
    task.standardOutput = outputPipe
    task.standardError = errorPipe

    try task.run()
    task.waitUntilExit()

    guard task.terminationStatus == 0 else {
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let msg = String(data: errorData, encoding: .utf8) ?? "Unknown osascript error"
        throw NSError(domain: "opencur.osascript", code: Int(task.terminationStatus), userInfo: [
            NSLocalizedDescriptionKey: msg.trimmingCharacters(in: .whitespacesAndNewlines)
        ])
    }

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: outputData, encoding: .utf8) ?? ""
}

struct FinderService {
    func targetDirectory() throws -> URL {
        guard NSWorkspace.shared.runningApplications.contains(where: { $0.bundleIdentifier == "com.apple.finder" }) else {
            throw FinderError.finderNotRunning
        }

        let output: String
        do {
            output = try runOScript(finderScript)
        } catch {
            let nsError = error as NSError
            let msg = nsError.localizedDescription
            if msg.contains("-1743") {
                throw FinderError.appleEventsPermissionDenied
            }
            throw FinderError.appleScriptError(code: nsError.code, message: msg)
        }

        let path = output.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !path.isEmpty else {
            throw FinderError.noSelection
        }

        return URL(fileURLWithPath: path)
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
