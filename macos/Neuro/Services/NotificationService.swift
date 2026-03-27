import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    private init() {}

    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func sendSessionCompleted(focusScore: Double, duration: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Session Complete"
        content.body = "Focus score: \(Int(focusScore))% over \(formattedDuration(duration))"
        content.sound = .default
        scheduleNotification(id: "session-complete-\(UUID().uuidString)", content: content)
    }

    func sendAppBlocked(appName: String) {
        let content = UNMutableNotificationContent()
        content.title = "App Blocked"
        content.body = "\(appName) was blocked during your focus session."
        content.sound = .default
        scheduleNotification(id: "app-blocked-\(UUID().uuidString)", content: content)
    }

    func sendStreakMilestone(days: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Streak Milestone!"
        content.body = "You've maintained a \(days)-day focus streak. Keep it up!"
        content.sound = .default
        scheduleNotification(id: "streak-\(days)-\(UUID().uuidString)", content: content)
    }

    func sendFriendSessionCompleted(friendName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Friend Finished a Session"
        content.body = "\(friendName) just completed a focus session."
        content.sound = .default
        scheduleNotification(id: "friend-session-\(UUID().uuidString)", content: content)
    }

    private func scheduleNotification(id: String, content: UNMutableNotificationContent) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request)
    }

    private func formattedDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        if minutes < 60 {
            return "\(minutes)m"
        }
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        if remainingMinutes == 0 {
            return "\(hours)h"
        }
        return "\(hours)h \(remainingMinutes)m"
    }
}
