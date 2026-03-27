import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(SettingsViewModel.self) private var settingsVM
    @Environment(AuthViewModel.self) private var authVM

    var body: some View {
        @Bindable var vm = settingsVM

        Form {
            // Account
            Section("Account") {
                if authVM.isAuthenticated, let user = authVM.currentUser {
                    LabeledContent("Email", value: user.email)
                    LabeledContent("Name", value: user.displayName ?? "")

                    Button("Sign Out", role: .destructive) {
                        authVM.signOut()
                    }
                } else {
                    Text("Not signed in")
                        .foregroundStyle(Color.neuroMuted)

                    Text("Sign in to sync data and connect with friends.")
                        .font(.caption)
                        .foregroundStyle(Color.neuroMuted)
                }
            }

            // Session Defaults
            Section("Session Defaults") {
                Picker("Default Duration", selection: $vm.defaultSessionDuration) {
                    ForEach(Constants.Session.presetDurations, id: \.self) { duration in
                        Text(duration.formatted()).tag(duration)
                    }
                }
            }

            // Notifications
            Section("Notifications") {
                Toggle("Show Notifications", isOn: $vm.showNotifications)
                Toggle("Play Sound", isOn: $vm.playSound)
            }

            // App Blocking
            Section("App Blocking") {
                NavigationLink {
                    BlockedAppsView()
                        .environment(settingsVM)
                } label: {
                    HStack {
                        Text("Blocked Apps")
                        Spacer()
                        Text("\(settingsVM.blockedApps.count)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.neuroAccent)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.neuroAccent.opacity(0.15), in: Capsule())
                    }
                }
            }

            // General
            Section("General") {
                Toggle("Launch at Login", isOn: $vm.launchAtLogin)
            }

            // About
            Section("About") {
                LabeledContent("Version", value: "1.0.0")
                LabeledContent("Build", value: "Beta")
            }
        }
        .formStyle(.grouped)
        .frame(width: 450, height: 500)
        .onAppear {
            settingsVM.loadBlockedApps()
        }
    }
}

#Preview {
    SettingsView()
        .environment(SettingsViewModel(
            modelContext: try! ModelContainer(for: BlockedApp.self).mainContext
        ))
        .environment(AuthViewModel(authService: MockAuthService()))
}
