import SwiftUI

// MARK: - SessionSetupView

/// Full session setup view with duration slider, presets, and blocked-app summary.
struct SessionSetupView: View {
    @Environment(SessionViewModel.self) private var sessionVM
    @Environment(SettingsViewModel.self) private var settingsVM
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header

            Divider().overlay(Color.neuroBorder)

            ScrollView {
                VStack(spacing: 24) {
                    durationSection
                    blockedAppsSection
                    startButton
                }
                .padding(20)
            }
        }
        .frame(width: 360)
        .background(Color.neuroBackground)
        .preferredColorScheme(.dark)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.neuroMuted)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Session Setup")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            // Invisible spacer to balance the close button
            Color.clear.frame(width: 16, height: 16)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Duration

    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DURATION")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.neuroMuted)

            // Large duration display
            Text(sessionVM.selectedDuration.formatted())
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)

            // Slider
            Slider(
                value: Binding(
                    get: { sessionVM.selectedDuration },
                    set: { sessionVM.selectedDuration = $0 }
                ),
                in: Constants.Session.minimumDuration...Constants.Session.maximumDuration,
                step: 60 * 5
            )
            .tint(Color.neuroAccent)

            // Preset buttons
            presetButtons
        }
    }

    @ViewBuilder
    private var presetButtons: some View {
        let presets = Constants.Session.presetDurations
        let labels = ["15m", "25m", "45m", "1h", "1.5h", "2h"]

        HStack(spacing: 6) {
            ForEach(Array(zip(presets, labels)), id: \.0) { duration, label in
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        sessionVM.selectedDuration = duration
                    }
                } label: {
                    Text(label)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(
                            sessionVM.selectedDuration == duration ? .white : Color.neuroMuted
                        )
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            sessionVM.selectedDuration == duration
                                ? Color.neuroAccent
                                : Color.neuroSurface,
                            in: RoundedRectangle(cornerRadius: 6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
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

    // MARK: - Blocked Apps

    private var blockedAppsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("BLOCKED APPS")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.neuroMuted)

            HStack {
                Image(systemName: "nosign")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.neuroDanger)

                Text("\(settingsVM.blockedApps.count) app\(settingsVM.blockedApps.count == 1 ? "" : "s") will be blocked")
                    .font(.system(size: 13))
                    .foregroundStyle(.white)

                Spacer()

                Button {
                    // Navigate to settings to customize blocked apps
                } label: {
                    Text("Customize")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.neuroAccent)
                }
                .buttonStyle(.plain)
            }
            .padding(12)
            .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.neuroBorder, lineWidth: 1)
            )
        }
    }

    // MARK: - Start Button

    private var startButton: some View {
        Button {
            sessionVM.startSession()
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile.fill")
                    .font(.system(size: 15))
                Text("Start Focus Session")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.neuroAccent, in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    SessionSetupView()
        .environment(SessionViewModel())
        .environment(SettingsViewModel())
}
