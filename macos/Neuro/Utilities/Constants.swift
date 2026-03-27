import Foundation

enum Constants {
    enum Session {
        static let defaultDuration: TimeInterval = 25 * 60 // 25 minutes
        static let minimumDuration: TimeInterval = 5 * 60  // 5 minutes
        static let maximumDuration: TimeInterval = 180 * 60 // 3 hours
        static let presetDurations: [TimeInterval] = [15*60, 25*60, 45*60, 60*60, 90*60, 120*60]
    }

    enum FocusScore {
        static let excellent: Double = 90
        static let good: Double = 70
        static let fair: Double = 50
    }

    enum Streak {
        static let milestoneIntervals = [7, 14, 30, 60, 100, 365]
    }

    enum UI {
        static let menuBarPopoverWidth: CGFloat = 360
        static let menuBarPopoverHeight: CGFloat = 480
    }

    enum Firebase {
        enum Collections {
            static let users = "users"
            static let friends = "friends"
            static let sessions = "sessions"
        }
    }
}
