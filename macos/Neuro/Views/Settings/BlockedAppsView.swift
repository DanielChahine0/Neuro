import SwiftUI

struct BlockedAppsView: View {
    @Environment(SettingsViewModel.self) private var settingsVM

    var body: some View {
        @Bindable var vm = settingsVM

        VStack(spacing: 0) {
            // Search
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.neuroMuted)

                TextField("Search apps...", text: $vm.searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))

                if !settingsVM.searchText.isEmpty {
                    Button {
                        settingsVM.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.neuroMuted)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(10)
            .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.neuroBorder, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider().overlay(Color.neuroBorder)

            List {
                // Blocked apps
                if !settingsVM.blockedApps.isEmpty {
                    Section {
                        ForEach(settingsVM.blockedApps) { app in
                            blockedAppRow(app)
                        }
                    } header: {
                        Label("Blocked (\(settingsVM.blockedApps.count))", systemImage: "nosign")
                            .foregroundStyle(Color.neuroDanger)
                    }
                }

                // Available apps
                Section {
                    if settingsVM.filteredApps.isEmpty {
                        Text("No matching apps found")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.neuroMuted)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 8)
                    } else {
                        ForEach(settingsVM.filteredApps, id: \.bundleId) { app in
                            availableAppRow(app)
                        }
                    }
                } header: {
                    Label("Available Apps", systemImage: "app.badge")
                }
            }
            .listStyle(.sidebar)
        }
        .frame(width: 450, minHeight: 400)
        .onAppear {
            settingsVM.loadBlockedApps()
            settingsVM.loadInstalledApps()
        }
    }

    private func blockedAppRow(_ app: BlockedApp) -> some View {
        HStack(spacing: 10) {
            appIcon(from: app.iconData)

            VStack(alignment: .leading, spacing: 1) {
                Text(app.appName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
                Text(app.bundleIdentifier)
                    .font(.system(size: 10))
                    .foregroundStyle(Color.neuroMuted)
                    .lineLimit(1)
            }

            Spacer()

            Button {
                settingsVM.removeBlockedApp(app)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.neuroDanger)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 2)
    }

    private func availableAppRow(_ app: (name: String, bundleId: String, icon: NSImage?)) -> some View {
        HStack(spacing: 10) {
            if let icon = app.icon {
                Image(nsImage: icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.neuroSurface)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "app.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.neuroMuted)
                    )
            }

            VStack(alignment: .leading, spacing: 1) {
                Text(app.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
                Text(app.bundleId)
                    .font(.system(size: 10))
                    .foregroundStyle(Color.neuroMuted)
                    .lineLimit(1)
            }

            Spacer()

            Button {
                settingsVM.addBlockedApp(name: app.name, bundleId: app.bundleId, icon: app.icon)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.neuroAccent)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 2)
    }

    private func appIcon(from data: Data?) -> some View {
        Group {
            if let data, let image = NSImage(data: data) {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.neuroDanger.opacity(0.15))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "nosign")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.neuroDanger)
                    )
            }
        }
    }
}

#Preview {
    BlockedAppsView()
        .environment(SettingsViewModel(
            modelContext: try! ModelContainer(for: BlockedApp.self).mainContext
        ))
}
