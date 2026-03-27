import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: String
    var email: String
    var displayName: String
    var createdAt: Date
    var currentStreak: Int
    var longestStreak: Int
    var lastSessionDate: Date?
    var totalFocusTime: TimeInterval
    var totalSessions: Int

    init(
        id: String,
        email: String,
        displayName: String,
        createdAt: Date,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastSessionDate: Date? = nil,
        totalFocusTime: TimeInterval = 0,
        totalSessions: Int = 0
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.createdAt = createdAt
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastSessionDate = lastSessionDate
        self.totalFocusTime = totalFocusTime
        self.totalSessions = totalSessions
    }
}
