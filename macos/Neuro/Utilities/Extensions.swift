import SwiftUI

// MARK: - TimeInterval

extension TimeInterval {
    /// Formats seconds into a human-readable duration string like "1h 25m" or "25m 30s".
    func formatted() -> String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }

    /// Formats seconds into a timer string like "01:25:30" (HH:MM:SS).
    func formattedTimer() -> String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - Date

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }

    func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: self) ?? self
    }
}

// MARK: - Double

extension Double {
    /// Returns a color representing the focus score quality.
    var focusScoreColor: Color {
        switch self {
        case Constants.FocusScore.excellent...: return .green
        case Constants.FocusScore.good...: return .yellow
        case Constants.FocusScore.fair...: return .orange
        default: return .red
        }
    }

    /// Returns a human-readable label for the focus score.
    var focusScoreLabel: String {
        switch self {
        case Constants.FocusScore.excellent...: return "Excellent"
        case Constants.FocusScore.good...: return "Good"
        case Constants.FocusScore.fair...: return "Fair"
        default: return "Needs Work"
        }
    }
}

// MARK: - Color

extension Color {
    static let neuroAccent = Color(red: 99 / 255, green: 102 / 255, blue: 241 / 255) // #6366f1
    static let neuroBackground = Color(red: 10 / 255, green: 10 / 255, blue: 10 / 255)
    static let neuroSurface = Color(red: 20 / 255, green: 20 / 255, blue: 20 / 255)
    static let neuroMuted = Color(red: 136 / 255, green: 136 / 255, blue: 136 / 255)
    static let neuroBorder = Color(red: 31 / 255, green: 31 / 255, blue: 31 / 255)
    static let neuroSuccess = Color.green
    static let neuroWarning = Color.orange
    static let neuroDanger = Color.red
}

// MARK: - NSRunningApplication

extension NSRunningApplication {
    var displayName: String {
        localizedName ?? bundleIdentifier ?? "Unknown"
    }
}

// MARK: - Int

extension Int {
    /// Returns the ordinal string representation (e.g., 1st, 2nd, 3rd, 4th).
    var ordinal: String {
        let suffix: String
        let ones = self % 10
        let tens = (self % 100) / 10

        if tens == 1 {
            suffix = "th"
        } else {
            switch ones {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }

        return "\(self)\(suffix)"
    }
}
