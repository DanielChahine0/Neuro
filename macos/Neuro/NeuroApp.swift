import SwiftUI
import SwiftData

@main
struct NeuroApp: App {
    @State private var sessionViewModel: SessionViewModel
    @State private var authViewModel: AuthViewModel
    @State private var statsViewModel: StatsViewModel
    @State private var socialViewModel: SocialViewModel
    @State private var settingsViewModel: SettingsViewModel

    private let modelContainer: ModelContainer
    private let monitorService: AppMonitorService
    private let blockerService: AppBlockerService
    private let authService: MockAuthService
    private let socialService: MockSocialService

    init() {
        let schema = Schema([
            FocusSession.self,
            AppUsageRecord.self,
            BlockedApp.self,
            UserProfile.self,
            Friend.self
        ])

        let config = ModelConfiguration("Neuro", schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [config])
            self.modelContainer = container

            let context = container.mainContext
            let monitor = AppMonitorService()
            let blocker = AppBlockerService()
            let auth = MockAuthService()
            let social = MockSocialService()

            self.monitorService = monitor
            self.blockerService = blocker
            self.authService = auth
            self.socialService = social

            _sessionViewModel = State(initialValue: SessionViewModel(
                modelContext: context,
                monitorService: monitor,
                blockerService: blocker
            ))
            _authViewModel = State(initialValue: AuthViewModel(authService: auth))
            _statsViewModel = State(initialValue: StatsViewModel(modelContext: context))
            _socialViewModel = State(initialValue: SocialViewModel(
                socialService: social,
                modelContext: context,
                userId: auth.currentUser?.uid ?? ""
            ))
            _settingsViewModel = State(initialValue: SettingsViewModel(modelContext: context))
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .environment(sessionViewModel)
                .environment(authViewModel)
                .environment(statsViewModel)
                .environment(socialViewModel)
                .environment(settingsViewModel)
                .modelContainer(modelContainer)
        } label: {
            CompactTimerView(isActive: sessionViewModel.isSessionActive,
                           timeRemaining: sessionViewModel.timeRemaining)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .environment(settingsViewModel)
                .environment(authViewModel)
                .modelContainer(modelContainer)
        }
    }
}
