import SwiftUI

// MARK: - SessionSummaryView

/// Shown after a focus session ends. Displays the score, stats, and app breakdown.
struct SessionSummaryView: View {
    let session: FocusSession
    var onDismiss: () -> Void = {}

    @State private var animateIn = false

    var body: some View {
        VStack(spacing: 0) {
            header

            Divider().overlay(Color.neuroBorder)

            ScrollView {
                VStack(spacing: 24) {
                    congratsHeader
                    scoreCircle
                    statsGrid
                    appBreakdown
                    doneButton
                }
                .padding(20)
            }
        }
        .frame(width: 380, minHeight: 520)
        .background(Color.neuroBackground)
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.1)) {
                animateIn = true
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Session Complete")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Congrats

    private var congratsHeader: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.neuroSuccess)
                .scaleEffect(animateIn ? 1 : 0.5)
                .opacity(animateIn ? 1 : 0)

            Text("Great work!")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 10)
        }
    }

    // MARK: - Score Circle

    private var scoreCircle: some View {
        ZStack {
            // Track
            Circle()
                .strokeBorder(Color.neuroBorder, lineWidth: 8)

            // Score arc
            Circle()
                .trim(from: 0, to: animateIn ? session.focusScore / 100 : 0)
                .stroke(
                    session.focusScore.focusScoreColor,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1.0).delay(0.3), value: animateIn)

            VStack(spacing: 4) {
                Text("\(Int(session.focusScore))")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(session.focusScore.focusScoreColor)
                    .contentTransition(.numericText())

                Text(session.focusScore.focusScoreLabel)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(session.focusScore.focusScoreColor.opacity(0.8))
            }
        }
        .frame(width: 150, height: 150)
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        let distractionCount = session.appUsageRecords.filter(\.isDistraction).count
        let topApp = mostUsedApp

        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            statCell(
                icon: "clock.fill",
                iconColor: Color.neuroAccent,
                value: session.actualDuration.formatted(),
                label: "Duration"
            )

            statCell(
                icon: "exclamationmark.triangle.fill",
                iconColor: distractionCount > 0 ? Color.neuroWarning : Color.neuroSuccess,
                value: "\(distractionCount)",
                label: "Distractions"
            )

            statCell(
                icon: "app.fill",
                iconColor: Color.neuroAccent,
                value: topApp ?? "---",
                label: "Top App"
            )
        }
    }

    private func statCell(icon: String, iconColor: Color, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(iconColor)

            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(Color.neuroMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.neuroBorder, lineWidth: 1)
        )
    }

    // MARK: - App Breakdown

    @ViewBuilder
    private var appBreakdown: some View {
        if !session.appUsageRecords.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("APP BREAKDOWN")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.neuroMuted)

                VStack(spacing: 6) {
                    ForEach(appSummaries.prefix(6), id: \.name) { app in
                        appRow(app)
                    }
                }
                .padding(12)
                .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.neuroBorder, lineWidth: 1)
                )
            }
        }
    }

    private func appRow(_ app: AppSummary) -> some View {
        VStack(spacing: 4) {
            HStack {
                Circle()
                    .fill(app.isDistraction ? Color.neuroDanger : Color.neuroSuccess)
                    .frame(width: 6, height: 6)

                Text(app.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Spacer()

                Text(app.duration.formatted())
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Color.neuroMuted)
            }

            // Time bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.neuroBorder)
                        .frame(height: 3)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(app.isDistraction ? Color.neuroDanger : Color.neuroAccent)
                        .frame(width: geometry.size.width * app.fraction, height: 3)
                        .animation(.easeOut(duration: 0.6).delay(0.5), value: animateIn)
                }
            }
            .frame(height: 3)
        }
    }

    // MARK: - Done Button

    private var doneButton: some View {
        Button {
            onDismiss()
        } label: {
            Text("Done")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.neuroAccent, in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Data Helpers

    private struct AppSummary {
        let name: String
        let duration: TimeInterval
        let isDistraction: Bool
        let fraction: Double
    }

    private var appSummaries: [AppSummary] {
        // Group records by app name and sum durations
        var grouped: [String: (duration: TimeInterval, isDistraction: Bool)] = [:]

        for record in session.appUsageRecords {
            let existing = grouped[record.appName]
            grouped[record.appName] = (
                duration: (existing?.duration ?? 0) + record.duration,
                isDistraction: record.isDistraction
            )
        }

        let maxDuration = grouped.values.map(\.duration).max() ?? 1

        return grouped
            .map { name, info in
                AppSummary(
                    name: name,
                    duration: info.duration,
                    isDistraction: info.isDistraction,
                    fraction: info.duration / maxDuration
                )
            }
            .sorted { $0.duration > $1.duration }
    }

    private var mostUsedApp: String? {
        appSummaries.first?.name
    }
}

// MARK: - Preview

#Preview {
    SessionSummaryView(
        session: FocusSession(
            startDate: Date().addingTimeInterval(-25 * 60),
            endDate: Date(),
            plannedDuration: 25 * 60,
            focusScore: 87,
            isCompleted: true
        )
    )
}
