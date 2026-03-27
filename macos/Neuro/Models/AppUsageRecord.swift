import Foundation
import SwiftData

@Model
final class AppUsageRecord {
    var id: UUID
    var appName: String
    var bundleIdentifier: String
    var startTime: Date
    var endTime: Date?
    var isDistraction: Bool
    var session: FocusSession?

    var duration: TimeInterval {
        (endTime ?? Date()).timeIntervalSince(startTime)
    }

    init(
        id: UUID = UUID(),
        appName: String,
        bundleIdentifier: String,
        startTime: Date,
        endTime: Date? = nil,
        isDistraction: Bool = false,
        session: FocusSession? = nil
    ) {
        self.id = id
        self.appName = appName
        self.bundleIdentifier = bundleIdentifier
        self.startTime = startTime
        self.endTime = endTime
        self.isDistraction = isDistraction
        self.session = session
    }
}
