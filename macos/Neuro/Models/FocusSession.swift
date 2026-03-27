import Foundation
import SwiftData

@Model
final class FocusSession {
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var plannedDuration: TimeInterval
    var focusScore: Double
    var isCompleted: Bool

    @Relationship(deleteRule: .cascade, inverse: \AppUsageRecord.session)
    var appUsageRecords: [AppUsageRecord]

    var actualDuration: TimeInterval {
        (endDate ?? Date()).timeIntervalSince(startDate)
    }

    var isActive: Bool {
        endDate == nil && !isCompleted
    }

    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date? = nil,
        plannedDuration: TimeInterval,
        focusScore: Double = 0,
        isCompleted: Bool = false,
        appUsageRecords: [AppUsageRecord] = []
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.plannedDuration = plannedDuration
        self.focusScore = focusScore
        self.isCompleted = isCompleted
        self.appUsageRecords = appUsageRecords
    }
}
