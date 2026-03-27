import SwiftUI

// MARK: - SessionView

/// Expanded active session detail view with a large progress ring, app timeline, and controls.
struct SessionView: View {
    @Environment(SessionViewModel.self) private var sessionVM

    var body: some View {
        VStack(spacing: 0) {
            header

            Divider().overlay(Color.neuroBorder)

            ScrollView {
                VStack(spacing: 20) {
                    progressRing
                    currentAppSection
                    appTimeline
                    controlButtons
                }
                .padding(20)
            }
        }
        .frame(width: 400, minHeight: 560)
        .background(Color.neuroBackground)
        .preferredColorScheme(.dark)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Focus Session")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            distractionCountBadge
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var distractionCountBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 10))
                .foregroundStyle(Color.neuroWarning)
            Text("\(sessionVM.recentDistractions.count)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.neuroSurface, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.neuroBorder, lineWidth: 1))
    }

    // MARK: - Progress Ring

    private var progressRing: some View {
        ZStack {
            // Track ring
            Circle()
                .strokeBorder(Color.neuroBorder, lineWidth: 8)

            // Progress arc
            ProgressArc(progress: sessionVM.progress)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color.neuroAccent.opacity(0.6),
                            Color.neuroAccent,
                        ],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(-90 + 360 * sessionVM.progress)
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: sessionVM.progress)

            // Glow dot at tip
            Circle()
                .fill(Color.neuroAccent)
                .frame(width: 12, height: 12)
                .shadow(color: Color.neuroAccent.opacity(0.6), radius: 6)
                .offset(y: -100)
                .rotationEffect(.degrees(360 * sessionVM.progress))
                .animation(.easeInOut(duration: 0.8), value: sessionVM.progress)

            // Center content
            VStack(spacing: 6) {
                Text(sessionVM.timeRemaining.formattedTimer())
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

                if sessionVM.isOvertime {
                    Label("Overtime", systemImage: "exclamationmark.circle.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.neuroWarning)
                } else if sessionVM.isPaused {
                    Label("Paused", systemImage: "pause.circle.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.neuroMuted)
                }

                // Focus score
                HStack(spacing: 4) {
                    Circle()
                        .fill(sessionVM.currentFocusScore.focusScoreColor)
                        .frame(width: 6, height: 6)
                    Text("\(Int(sessionVM.currentFocusScore))% \(sessionVM.currentFocusScore.focusScoreLabel)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(sessionVM.currentFocusScore.focusScoreColor)
                }
                .padding(.top, 2)
            }
        }
        .frame(width: 200, height: 200)
        .padding(.top, 8)
    }

    // MARK: - Current App

    private var currentAppSection: some View {
        HStack(spacing: 12) {
            // Status dot
            ZStack {
                Circle()
                    .fill(
                        sessionVM.currentAppIsDistraction
                            ? Color.neuroDanger.opacity(0.15)
                            : Color.neuroSuccess.opacity(0.15)
                    )
                    .frame(width: 36, height: 36)

                Image(systemName: sessionVM.currentAppIsDistraction ? "xmark.app.fill" : "checkmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(
                        sessionVM.currentAppIsDistraction ? Color.neuroDanger : Color.neuroSuccess
                    )
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Current App")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.neuroMuted)
                Text(sessionVM.currentAppName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }

            Spacer()

            Text(sessionVM.currentAppIsDistraction ? "Distraction" : "Focused")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(
                    sessionVM.currentAppIsDistraction ? Color.neuroDanger : Color.neuroSuccess
                )
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    (sessionVM.currentAppIsDistraction ? Color.neuroDanger : Color.neuroSuccess)
                        .opacity(0.12),
                    in: Capsule()
                )
        }
        .padding(12)
        .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    sessionVM.currentAppIsDistraction
                        ? Color.neuroDanger.opacity(0.3)
                        : Color.neuroBorder,
                    lineWidth: 1
                )
        )
    }

    // MARK: - App Timeline

    private var appTimeline: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("APP TIMELINE")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.neuroMuted)

                Spacer()

                Text("\(sessionVM.recentDistractions.count) distraction\(sessionVM.recentDistractions.count == 1 ? "" : "s")")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.neuroWarning)
            }

            if sessionVM.recentDistractions.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color.neuroSuccess)
                    Text("No distractions yet. Keep it up!")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.neuroMuted)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 10))
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(sessionVM.recentDistractions.enumerated()), id: \.offset) { index, distraction in
                        HStack(spacing: 10) {
                            VStack(spacing: 0) {
                                Circle()
                                    .fill(Color.neuroDanger)
                                    .frame(width: 8, height: 8)

                                if index < sessionVM.recentDistractions.count - 1 {
                                    Rectangle()
                                        .fill(Color.neuroBorder)
                                        .frame(width: 1)
                                        .frame(maxHeight: .infinity)
                                }
                            }
                            .frame(width: 8)

                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Color.neuroWarning)

                                Text(distraction.app)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)

                                Spacer()

                                Text(distraction.duration.formatted())
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundStyle(Color.neuroMuted)
                            }
                            .padding(.vertical, 8)
                        }

                        if index < sessionVM.recentDistractions.count - 1 {
                            Divider().overlay(Color.neuroBorder)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.neuroBorder, lineWidth: 1)
                )
            }
        }
    }

    // MARK: - Controls

    private var controlButtons: some View {
        HStack(spacing: 12) {
            // Pause / Resume
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if sessionVM.isPaused {
                        sessionVM.resumeSession()
                    } else {
                        sessionVM.pauseSession()
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: sessionVM.isPaused ? "play.fill" : "pause.fill")
                        .font(.system(size: 14))
                    Text(sessionVM.isPaused ? "Resume" : "Pause")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.neuroBorder, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            // End Session
            Button {
                sessionVM.endSession()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 14))
                    Text("End Session")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.neuroDanger.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.neuroDanger.opacity(0.4), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - ProgressArc Shape

private struct ProgressArc: Shape {
    var progress: Double

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: min(rect.width, rect.height) / 2,
                startAngle: .degrees(0),
                endAngle: .degrees(360 * progress),
                clockwise: false
            )
        }
    }
}

// MARK: - Preview

#Preview {
    SessionView()
        .environment(SessionViewModel())
}
