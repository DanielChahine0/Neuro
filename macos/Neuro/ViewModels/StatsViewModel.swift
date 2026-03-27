import SwiftUI
import SwiftData

@MainActor @Observable
final class StatsViewModel {
    var todayFocusTime: TimeInterval = 0
    var weeklyFocusTime: TimeInterval = 0
    var monthlyFocusTime: TimeInterval = 0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var totalSessions: Int = 0
    var averageFocusScore: Double = 0
    var weeklySessionData: [(date: Date, focusTime: TimeInterval, distractionCount: Int)] = []
    var recentSessions: [FocusSession] = []

    enum TimePeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case allTime = "All Time"
    }

    var selectedPeriod: TimePeriod = .week

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadStats() {
        let completedSessions = fetchCompletedSessions()

        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfWeek = now.startOfWeek
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now

        todayFocusTime = completedSessions
            .filter { $0.startDate >= startOfToday }
            .reduce(0) { $0 + $1.actualDuration }

        weeklyFocusTime = completedSessions
            .filter { $0.startDate >= startOfWeek }
            .reduce(0) { $0 + $1.actualDuration }

        monthlyFocusTime = completedSessions
            .filter { $0.startDate >= startOfMonth }
            .reduce(0) { $0 + $1.actualDuration }

        totalSessions = completedSessions.count

        if !completedSessions.isEmpty {
            averageFocusScore = completedSessions.reduce(0) { $0 + $1.focusScore } / Double(completedSessions.count)
        } else {
            averageFocusScore = 0
        }

        loadProfile()
        buildWeeklySessionData(from: completedSessions)

        recentSessions = Array(completedSessions.prefix(10))
    }

    func sessionsForPeriod() -> [FocusSession] {
        let sessions = fetchCompletedSessions()
        let now = Date()

        switch selectedPeriod {
        case .week:
            return sessions.filter { $0.startDate >= now.startOfWeek }
        case .month:
            let calendar = Calendar.current
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
            return sessions.filter { $0.startDate >= startOfMonth }
        case .allTime:
            return sessions
        }
    }

    func chartData() -> [(date: Date, hours: Double)] {
        let sessions = sessionsForPeriod()
        let calendar = Calendar.current
        var grouped: [Date: TimeInterval] = [:]

        for session in sessions {
            let day = calendar.startOfDay(for: session.startDate)
            grouped[day, default: 0] += session.actualDuration
        }

        return grouped
            .map { (date: $0.key, hours: $0.value / 3600.0) }
            .sorted { $0.date < $1.date }
    }

    func distractionChartData() -> [(date: Date, count: Int)] {
        let sessions = sessionsForPeriod()
        let calendar = Calendar.current
        var grouped: [Date: Int] = [:]

        for session in sessions {
            let day = calendar.startOfDay(for: session.startDate)
            let distractionCount = session.appUsageRecords.filter(\.isDistraction).count
            grouped[day, default: 0] += distractionCount
        }

        return grouped
            .map { (date: $0.key, count: $0.value) }
            .sorted { $0.date < $1.date }
    }

    private func fetchCompletedSessions() -> [FocusSession] {
        var descriptor = FetchDescriptor<FocusSession>(
            predicate: #Predicate { $0.isCompleted },
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        descriptor.relationshipKeyPathsForPrefetching = [\FocusSession.appUsageRecords]

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            return []
        }
    }

    private func loadProfile() {
        let descriptor = FetchDescriptor<UserProfile>()
        do {
            if let profile = try modelContext.fetch(descriptor).first {
                currentStreak = profile.currentStreak
                longestStreak = profile.longestStreak
            }
        } catch {
            // Profile not available
        }
    }

    private func buildWeeklySessionData(from sessions: [FocusSession]) {
        let calendar = Calendar.current
        let startOfWeek = Date().startOfWeek
        let weeklySessions = sessions.filter { $0.startDate >= startOfWeek }
        var grouped: [Date: (focusTime: TimeInterval, distractionCount: Int)] = [:]

        for session in weeklySessions {
            let day = calendar.startOfDay(for: session.startDate)
            var entry = grouped[day, default: (focusTime: 0, distractionCount: 0)]
            entry.focusTime += session.actualDuration
            entry.distractionCount += session.appUsageRecords.filter(\.isDistraction).count
            grouped[day] = entry
        }

        weeklySessionData = grouped
            .map { (date: $0.key, focusTime: $0.value.focusTime, distractionCount: $0.value.distractionCount) }
            .sorted { $0.date < $1.date }
    }
}
