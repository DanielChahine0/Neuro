import SwiftUI

// MARK: - MenuBarView

struct MenuBarView: View {
    @Environment(SessionViewModel.self) private var sessionVM
    @Environment(StatsViewModel.self) private var statsVM
    @Environment(SocialViewModel.self) private var socialVM
    @Environment(SettingsViewModel.self) private var settingsVM

    @State private var selectedTab: Tab = .home

    enum Tab: String, CaseIterable {
        case home, stats, social, profile

        var icon: String {
            switch self {
            case .home: "house.fill"
            case .stats: "chart.bar.fill"
            case .social: "person.2.fill"
            case .profile: "person.crop.circle.fill"
            }
        }

        var label: String {
            switch self {
            case .home: "Home"
            case .stats: "Stats"
            case .social: "Social"
            case .profile: "Profile"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            topBar

            Divider()
                .overlay(Color.neuroBorder)

            // Content
            Group {
                switch selectedTab {
                case .home:
                    if sessionVM.isSessionActive {
                        ActiveSessionView()
                    } else {
                        QuickStartView()
                    }
                case .stats:
                    StatsView(viewModel: statsVM)
                case .social:
                    FriendsListView()
                case .profile:
                    profileView
                }
            }
            .frame(maxHeight: .infinity)

            Divider()
                .overlay(Color.neuroBorder)

            // Tab bar
            tabBar
        }
        .frame(width: Constants.UI.menuBarPopoverWidth)
        .frame(minHeight: Constants.UI.menuBarPopoverHeight)
        .background(Color.neuroBackground)
        .preferredColorScheme(.dark)
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Text("Neuro")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Spacer()

            Button {
                // Open settings
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.neuroMuted)
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Tab Bar

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 16))
                        Text(tab.label)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(selectedTab == tab ? Color.neuroAccent : Color.neuroMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 4)
    }

    // MARK: - Profile Tab

    @Environment(AuthViewModel.self) private var authVM

    private var profileView: some View {
        Group {
            if authVM.isAuthenticated {
                VStack(spacing: 16) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(Color.neuroAccent.opacity(0.2))
                            .frame(width: 56, height: 56)

                        Text(String((authVM.currentUser?.displayName ?? authVM.currentUser?.email ?? "?").prefix(1)).uppercased())
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(Color.neuroAccent)
                    }

                    VStack(spacing: 4) {
                        Text(authVM.currentUser?.displayName ?? "")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                        Text(authVM.currentUser?.email ?? "")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.neuroMuted)
                    }

                    StreakView(
                        currentStreak: statsVM.currentStreak,
                        longestStreak: statsVM.longestStreak,
                        weeklyActivity: []
                    )
                    .padding(.horizontal, 16)

                    Button {
                        authVM.signOut()
                    } label: {
                        Text("Sign Out")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.neuroDanger)
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .padding(.top, 24)
            } else {
                LoginView()
                    .padding(16)
            }
        }
    }
}

// MARK: - QuickStartView

private struct QuickStartView: View {
    @Environment(SessionViewModel.self) private var sessionVM
    @Environment(StatsViewModel.self) private var statsVM
    @Environment(SocialViewModel.self) private var socialVM

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Streak & today's focus
                HStack(spacing: 12) {
                    statBadge(
                        icon: "flame.fill",
                        iconColor: .orange,
                        value: "\(statsVM.currentStreak)",
                        label: "day streak"
                    )

                    statBadge(
                        icon: "clock.fill",
                        iconColor: Color.neuroAccent,
                        value: statsVM.todayFocusTime.formatted(),
                        label: "today"
                    )
                }
                .padding(.horizontal, 16)

                // Duration picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Duration")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.neuroMuted)
                        .textCase(.uppercase)

                    durationPicker
                }
                .padding(.horizontal, 16)

                // Start button
                Button {
                    sessionVM.startSession()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "brain.head.profile.fill")
                            .font(.system(size: 14))
                        Text("Start Focus Session")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.neuroAccent, in: RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)

                // Active friends
                if !socialVM.activeFriends.isEmpty {
                    activeFriendsSection
                }
            }
            .padding(.vertical, 16)
        }
    }

    private func statBadge(icon: String, iconColor: Color, value: String, label: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(iconColor)

            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(label)
                    .font(.system(size: 10))
                    .foregroundStyle(Color.neuroMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.neuroBorder, lineWidth: 1)
        )
    }

    @ViewBuilder
    private var durationPicker: some View {
        let presets = Constants.Session.presetDurations
        let labels = ["15m", "25m", "45m", "1h", "1.5h", "2h"]

        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
            ForEach(Array(zip(presets, labels)), id: \.0) { duration, label in
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        sessionVM.selectedDuration = duration
                    }
                } label: {
                    Text(label)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(sessionVM.selectedDuration == duration ? .white : Color.neuroMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            sessionVM.selectedDuration == duration
                                ? Color.neuroAccent
                                : Color.neuroSurface,
                            in: RoundedRectangle(cornerRadius: 8)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(
                                    sessionVM.selectedDuration == duration
                                        ? Color.clear
                                        : Color.neuroBorder,
                                    lineWidth: 1
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var activeFriendsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 6, height: 6)
                Text("\(socialVM.activeFriends.count) friend\(socialVM.activeFriends.count == 1 ? "" : "s") focusing")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.neuroMuted)
            }

            HStack(spacing: -6) {
                ForEach(socialVM.activeFriends.prefix(3)) { friend in
                    Circle()
                        .fill(Color.neuroAccent.opacity(0.3))
                        .overlay(
                            Text(String(friend.displayName.prefix(1)).uppercased())
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color.neuroAccent)
                        )
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle().strokeBorder(Color.neuroBackground, lineWidth: 2)
                        )
                }

                if socialVM.activeFriends.count > 3 {
                    Circle()
                        .fill(Color.neuroSurface)
                        .overlay(
                            Text("+\(socialVM.activeFriends.count - 3)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Color.neuroMuted)
                        )
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle().strokeBorder(Color.neuroBackground, lineWidth: 2)
                        )
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.neuroBorder, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - ActiveSessionView

private struct ActiveSessionView: View {
    @Environment(SessionViewModel.self) private var sessionVM

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Progress ring
                progressRing

                // Focus score
                focusScoreBadge

                // Current app
                currentAppIndicator

                // Recent distractions
                if !sessionVM.recentDistractions.isEmpty {
                    recentDistractionsSection
                }

                // Controls
                controlButtons
            }
            .padding(16)
        }
    }

    private var progressRing: some View {
        ZStack {
            // Track
            Circle()
                .strokeBorder(Color.neuroBorder, lineWidth: 6)

            // Progress
            Circle()
                .trim(from: 0, to: sessionVM.progress)
                .stroke(
                    Color.neuroAccent,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: sessionVM.progress)

            // Time
            VStack(spacing: 4) {
                Text(sessionVM.timeRemaining.formattedTimer())
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)

                if sessionVM.isOvertime {
                    Text("OVERTIME")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.neuroWarning)
                } else if sessionVM.isPaused {
                    Text("PAUSED")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.neuroMuted)
                } else {
                    Text("remaining")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.neuroMuted)
                }
            }
        }
        .frame(width: 160, height: 160)
    }

    private var focusScoreBadge: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(sessionVM.currentFocusScore.focusScoreColor)
                .frame(width: 8, height: 8)

            Text("Focus: \(Int(sessionVM.currentFocusScore))%")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)

            Text(sessionVM.currentFocusScore.focusScoreLabel)
                .font(.system(size: 11))
                .foregroundStyle(sessionVM.currentFocusScore.focusScoreColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.neuroSurface, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.neuroBorder, lineWidth: 1))
    }

    private var currentAppIndicator: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(sessionVM.currentAppIsDistraction ? Color.neuroDanger : Color.neuroSuccess)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(sessionVM.currentAppName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(sessionVM.currentAppIsDistraction ? "Distraction" : "Focused")
                    .font(.system(size: 11))
                    .foregroundStyle(
                        sessionVM.currentAppIsDistraction ? Color.neuroDanger : Color.neuroMuted
                    )
            }

            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    sessionVM.currentAppIsDistraction ? Color.neuroDanger.opacity(0.3) : Color.neuroBorder,
                    lineWidth: 1
                )
        )
    }

    private var recentDistractionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Distractions")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.neuroMuted)
                .textCase(.uppercase)

            ForEach(Array(sessionVM.recentDistractions.prefix(3).enumerated()), id: \.offset) { _, distraction in
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.neuroWarning)

                    Text(distraction.app)
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Spacer()

                    Text(distraction.duration.formatted())
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(Color.neuroMuted)
                }
            }
        }
        .padding(12)
        .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.neuroBorder, lineWidth: 1)
        )
    }

    private var controlButtons: some View {
        HStack(spacing: 10) {
            // Pause / Resume
            Button {
                if sessionVM.isPaused {
                    sessionVM.resumeSession()
                } else {
                    sessionVM.pauseSession()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: sessionVM.isPaused ? "play.fill" : "pause.fill")
                        .font(.system(size: 12))
                    Text(sessionVM.isPaused ? "Resume" : "Pause")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.neuroBorder, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            // End Session
            Button {
                sessionVM.endSession()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 12))
                    Text("End")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.neuroDanger.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.neuroDanger.opacity(0.4), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Preview

#Preview {
    MenuBarView()
        .environment(SessionViewModel())
        .environment(StatsViewModel())
        .environment(SocialViewModel())
        .environment(SettingsViewModel())
}
