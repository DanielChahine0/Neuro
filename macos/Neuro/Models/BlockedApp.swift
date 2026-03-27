import Foundation
import SwiftData

@Model
final class BlockedApp {
    var id: UUID
    var appName: String
    var bundleIdentifier: String
    var iconData: Data?
    var dateAdded: Date

    init(
        id: UUID = UUID(),
        appName: String,
        bundleIdentifier: String,
        iconData: Data? = nil,
        dateAdded: Date = .now
    ) {
        self.id = id
        self.appName = appName
        self.bundleIdentifier = bundleIdentifier
        self.iconData = iconData
        self.dateAdded = dateAdded
    }
}
