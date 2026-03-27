import Foundation
import SwiftData

@Model
final class Friend {
    @Attribute(.unique) var id: String
    var email: String
    var displayName: String
    var isInSession: Bool
    var currentStreak: Int
    var weeklyFocusTime: TimeInterval
    var lastUpdated: Date

    init(
        id: String,
        email: String,
        displayName: String,
        isInSession: Bool = false,
        currentStreak: Int = 0,
        weeklyFocusTime: TimeInterval = 0,
        lastUpdated: Date = .now
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.isInSession = isInSession
        self.currentStreak = currentStreak
        self.weeklyFocusTime = weeklyFocusTime
        self.lastUpdated = lastUpdated
    }
}
