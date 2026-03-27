import SwiftUI
import SwiftData
import Combine

@MainActor @Observable
final class SessionViewModel {
    var isSessionActive = false
    var isPaused = false
    var elapsedTime: TimeInterval = 0
    var selectedDuration: TimeInterval = Constants.Session.defaultDuration
    var currentFocusScore: Double = 100
    var currentSession: FocusSession?
    var currentAppName: String = ""
    var currentAppIsDistraction: Bool = false
    var recentDistractions: [(app: String, duration: TimeInterval)] = []

    private let modelContext: ModelContext
    private let monitorService: AppMonitorService
    private let blockerService: AppBlockerService
    private var timer: Timer?
    private var currentRecord: AppUsageRecord?
    private var cancellables = Set<AnyCancellable>()

    var timeRemaining: TimeInterval {
        max(0, selectedDuration - elapsedTime)
    }

    var progress: Double {
        guard selectedDuration > 0 else { return 0 }
        return min(elapsedTime / selectedDuration, 1.0)
    }

    var isOvertime: Bool {
        elapsedTime > selectedDuration
    }

    init(modelContext: ModelContext, monitorService: AppMonitorService, blockerService: AppBlockerService) {
        self.modelContext = modelContext
        self.monitorService = monitorService
        self.blockerService = blockerService

        monitorService.onAppChange = { [weak self] name, bundleId in
            self?.onAppChanged(name: name, bundleId: bundleId)
        }
    }

    func startSession() {
        let session = FocusSession(
            startDate: .now,
            plannedDuration: selectedDuration
        )
        modelContext.insert(session)
        currentSession = session

        elapsedTime = 0
        currentFocusScore = 100
        isPaused = false
        isSessionActive = true
        recentDistractions = []

        monitorService.startMonitoring()
        blockerService.startBlocking(context: modelContext)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self, !self.isPaused else { return }
                self.elapsedTime += 1
                self.updateFocusScore()
            }
        }

        saveContext()
    }

    func pauseSession() {
        isPaused = true
        closeCurrentRecord()
    }

    func resumeSession() {
        isPaused = false
    }

    func endSession() {
        guard let session = currentSession else { return }

        timer?.invalidate()
        timer = nil
        monitorService.stopMonitoring()
        blockerService.stopBlocking()
        closeCurrentRecord()

        session.endDate = .now
        session.focusScore = FocusScoreService.calculateScore(
            records: session.appUsageRecords,
            sessionDuration: elapsedTime
        )
        session.isCompleted = true

        updateStreak(for: session)

        isSessionActive = false
        isPaused = false
        currentAppName = ""
        currentAppIsDistraction = false

        NotificationService.shared.sendSessionCompleted(
            focusScore: session.focusScore,
            duration: session.actualDuration
        )

        saveContext()
        currentSession = nil
    }

    func cancelSession() {
        timer?.invalidate()
        timer = nil
        monitorService.stopMonitoring()
        blockerService.stopBlocking()
        closeCurrentRecord()

        if let session = currentSession {
            modelContext.delete(session)
        }

        isSessionActive = false
        isPaused = false
        elapsedTime = 0
        currentFocusScore = 100
        currentAppName = ""
        currentAppIsDistraction = false
        recentDistractions = []
        currentSession = nil

        saveContext()
    }

    private func onAppChanged(name: String, bundleId: String) {
        guard isSessionActive, !isPaused else { return }

        closeCurrentRecord()

        let isDistraction = isBlockedApp(bundleId)

        let record = AppUsageRecord(
            appName: name,
            bundleIdentifier: bundleId,
            startTime: .now,
            isDistraction: isDistraction,
            session: currentSession
        )
        modelContext.insert(record)
        currentRecord = record
        currentSession?.appUsageRecords.append(record)

        currentAppName = name
        currentAppIsDistraction = isDistraction

        if isDistraction {
            if let index = recentDistractions.firstIndex(where: { $0.app == name }) {
                recentDistractions[index].duration += 0
            } else {
                recentDistractions.append((app: name, duration: 0))
            }
        }

        updateFocusScore()
    }

    private func closeCurrentRecord() {
        guard let record = currentRecord else { return }
        record.endTime = .now

        if record.isDistraction {
            if let index = recentDistractions.firstIndex(where: { $0.app == record.appName }) {
                recentDistractions[index].duration += record.duration
            }
        }

        currentRecord = nil
    }

    private func updateFocusScore() {
        guard let session = currentSession else { return }
        currentFocusScore = FocusScoreService.calculateScore(
            records: session.appUsageRecords,
            sessionDuration: elapsedTime
        )
    }

    private func isBlockedApp(_ bundleId: String) -> Bool {
        let descriptor = FetchDescriptor<BlockedApp>(
            predicate: #Predicate { $0.bundleIdentifier == bundleId }
        )
        do {
            let count = try modelContext.fetchCount(descriptor)
            return count > 0
        } catch {
            return false
        }
    }

    private func updateStreak(for session: FocusSession) {
        let descriptor = FetchDescriptor<UserProfile>()
        do {
            guard let profile = try modelContext.fetch(descriptor).first else { return }
            let result = FocusScoreService.updateStreak(
                lastSessionDate: profile.lastSessionDate,
                currentStreak: profile.currentStreak
            )
            profile.currentStreak = result.newStreak
            profile.longestStreak = max(profile.longestStreak, result.newStreak)
            profile.lastSessionDate = .now
            profile.totalFocusTime += session.actualDuration
            profile.totalSessions += 1

            if result.isNewDay {
                let milestones = Constants.Streak.milestoneIntervals
                if milestones.contains(result.newStreak) {
                    NotificationService.shared.sendStreakMilestone(days: result.newStreak)
                }
            }
        } catch {
            // Profile not found; skip streak update
        }
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            // Save failed silently
        }
    }
}
