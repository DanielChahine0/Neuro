import Foundation
import AppKit
import SwiftData

@MainActor
class AppBlockerService: ObservableObject {
    @Published var isBlocking = false
    @Published var blockedAttempts: [(appName: String, date: Date)] = []

    private var launchObserver: NSObjectProtocol?
    private var modelContext: ModelContext?
    private var blockedBundleIds: Set<String> = []
    private let notificationCenter = NSWorkspace.shared.notificationCenter

    func startBlocking(context: ModelContext) {
        guard !isBlocking else { return }
        modelContext = context
        refreshBlockedApps()

        launchObserver = notificationCenter.addObserver(
            forName: NSWorkspace.didLaunchApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self else { return }
            Task { @MainActor in
                self.handleAppLaunch(notification)
            }
        }

        isBlocking = true
        terminateRunningBlockedApps()
    }

    func stopBlocking() {
        if let observer = launchObserver {
            notificationCenter.removeObserver(observer)
            launchObserver = nil
        }
        isBlocking = false
        blockedBundleIds.removeAll()
        modelContext = nil
    }

    func refreshBlockedApps() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<BlockedApp>()
        do {
            let apps = try context.fetch(descriptor)
            blockedBundleIds = Set(apps.map(\.bundleIdentifier))
        } catch {
            blockedBundleIds = []
        }
    }

    private func handleAppLaunch(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        guard let bundleId = app.bundleIdentifier, isAppBlocked(bundleId) else {
            return
        }
        let appName = app.localizedName ?? bundleId
        terminateApp(app)
        blockedAttempts.append((appName: appName, date: Date()))
        NotificationService.shared.sendAppBlocked(appName: appName)
    }

    private func isAppBlocked(_ bundleId: String) -> Bool {
        blockedBundleIds.contains(bundleId)
    }

    private func terminateApp(_ app: NSRunningApplication) {
        if !app.terminate() {
            app.forceTerminate()
        }
    }

    private func terminateRunningBlockedApps() {
        let runningApps = NSWorkspace.shared.runningApplications
        for app in runningApps {
            guard let bundleId = app.bundleIdentifier, isAppBlocked(bundleId) else {
                continue
            }
            let appName = app.localizedName ?? bundleId
            terminateApp(app)
            blockedAttempts.append((appName: appName, date: Date()))
        }
    }
}
