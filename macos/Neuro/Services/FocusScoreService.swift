import Foundation

struct FocusScoreService {

    static func calculateScore(records: [AppUsageRecord], sessionDuration: TimeInterval) -> Double {
        guard sessionDuration > 0 else { return 0 }

        var focusedTime: TimeInterval = 0
        var totalTrackedTime: TimeInterval = 0

        for record in records {
            let end = record.endTime ?? Date()
            let duration = end.timeIntervalSince(record.startTime)
            guard duration > 0 else { continue }

            totalTrackedTime += duration
            if !record.isDistraction {
                focusedTime += duration
            }
        }

        let referenceTime = max(totalTrackedTime, sessionDuration)
        return calculateScore(focusedTime: focusedTime, totalTime: referenceTime)
    }

    static func calculateScore(focusedTime: TimeInterval, totalTime: TimeInterval) -> Double {
        guard totalTime > 0 else { return 0 }
        let raw = (focusedTime / totalTime) * 100
        return min(max(raw, 0), 100)
    }

    static func updateStreak(lastSessionDate: Date?, currentStreak: Int) -> (newStreak: Int, isNewDay: Bool) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        guard let lastDate = lastSessionDate else {
            return (newStreak: 1, isNewDay: true)
        }

        let lastDay = calendar.startOfDay(for: lastDate)

        if lastDay == today {
            return (newStreak: currentStreak, isNewDay: false)
        }

        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today), lastDay == yesterday {
            return (newStreak: currentStreak + 1, isNewDay: true)
        }

        return (newStreak: 1, isNewDay: true)
    }
}
