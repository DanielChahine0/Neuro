import SwiftUI
import SwiftData

@MainActor @Observable
final class SettingsViewModel {
    var blockedApps: [BlockedApp] = []
    var installedApps: [(name: String, bundleId: String, icon: NSImage?)] = []
    var searchText = ""
    var launchAtLogin = false
    var showNotifications = true
    var defaultSessionDuration: TimeInterval = Constants.Session.defaultDuration
    var playSound = true

    private let modelContext: ModelContext

    var filteredApps: [(name: String, bundleId: String, icon: NSImage?)] {
        let blockedIds = Set(blockedApps.map(\.bundleIdentifier))
        let available = installedApps.filter { !blockedIds.contains($0.bundleId) }

        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return available
        }

        let query = searchText.lowercased()
        return available.filter {
            $0.name.lowercased().contains(query) || $0.bundleId.lowercased().contains(query)
        }
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadBlockedApps() {
        let descriptor = FetchDescriptor<BlockedApp>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        do {
            blockedApps = try modelContext.fetch(descriptor)
        } catch {
            blockedApps = []
        }
    }

    func loadInstalledApps() {
        let fileManager = FileManager.default
        let appDirectories = [
            "/Applications",
            "/System/Applications",
            NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true).first
        ].compactMap { $0 }

        var apps: [(name: String, bundleId: String, icon: NSImage?)] = []
        var seenBundleIds = Set<String>()

        for directory in appDirectories {
            guard let contents = try? fileManager.contentsOfDirectory(atPath: directory) else {
                continue
            }

            for item in contents where item.hasSuffix(".app") {
                let path = (directory as NSString).appendingPathComponent(item)
                guard let bundle = Bundle(path: path),
                      let bundleId = bundle.bundleIdentifier else {
                    continue
                }

                guard !seenBundleIds.contains(bundleId) else { continue }
                seenBundleIds.insert(bundleId)

                let name = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String
                    ?? bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
                    ?? (item as NSString).deletingPathExtension

                let icon = NSWorkspace.shared.icon(forFile: path)
                apps.append((name: name, bundleId: bundleId, icon: icon))
            }
        }

        installedApps = apps.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    func addBlockedApp(name: String, bundleId: String, icon: NSImage?) {
        let iconData = icon?.tiffRepresentation

        let app = BlockedApp(
            appName: name,
            bundleIdentifier: bundleId,
            iconData: iconData
        )
        modelContext.insert(app)
        blockedApps.insert(app, at: 0)

        do {
            try modelContext.save()
        } catch {
            // Save failed silently
        }
    }

    func removeBlockedApp(_ app: BlockedApp) {
        modelContext.delete(app)
        blockedApps.removeAll { $0.id == app.id }

        do {
            try modelContext.save()
        } catch {
            // Save failed silently
        }
    }

    func isBlocked(_ bundleId: String) -> Bool {
        blockedApps.contains { $0.bundleIdentifier == bundleId }
    }
}
