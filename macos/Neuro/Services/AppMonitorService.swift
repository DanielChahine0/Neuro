import Foundation
import AppKit
import Combine

@MainActor
class AppMonitorService: ObservableObject {
    @Published var currentApp: (name: String, bundleId: String)?
    @Published var isMonitoring = false

    var onAppChange: ((_ name: String, _ bundleId: String) -> Void)?

    private var workspaceObservers: [NSObjectProtocol] = []
    private var pollingTimer: Timer?
    private let notificationCenter = NSWorkspace.shared.notificationCenter

    func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true

        let activateObserver = notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self else { return }
            Task { @MainActor in
                self.handleAppActivation(notification)
            }
        }
        workspaceObservers.append(activateObserver)

        pollingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.pollFrontmostApp()
            }
        }

        pollFrontmostApp()
    }

    func stopMonitoring() {
        isMonitoring = false

        for observer in workspaceObservers {
            notificationCenter.removeObserver(observer)
        }
        workspaceObservers.removeAll()

        pollingTimer?.invalidate()
        pollingTimer = nil

        currentApp = nil
    }

    private func handleAppActivation(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        updateCurrentApp(from: app)
    }

    private func pollFrontmostApp() {
        guard let app = NSWorkspace.shared.frontmostApplication else { return }
        updateCurrentApp(from: app)
    }

    private func updateCurrentApp(from app: NSRunningApplication) {
        let name = app.localizedName ?? "Unknown"
        let bundleId = app.bundleIdentifier ?? "unknown"

        if currentApp?.bundleId != bundleId {
            currentApp = (name: name, bundleId: bundleId)
            onAppChange?(name, bundleId)
        }
    }

    deinit {
        pollingTimer?.invalidate()
    }
}
