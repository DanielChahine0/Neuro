import SwiftUI

// MARK: - CompactTimerView

/// Displayed inline in the macOS system menu bar.
/// Shows a brain icon when idle, or a countdown timer during an active session.
struct CompactTimerView: View {
    @Environment(SessionViewModel.self) private var sessionVM

    var body: some View {
        if sessionVM.isSessionActive {
            HStack(spacing: 4) {
                Image(systemName: sessionVM.isPaused ? "pause.circle.fill" : "brain.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(sessionVM.isPaused ? Color.neuroMuted : Color.neuroAccent)

                Text(timerText)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .monospacedDigit()
                    .foregroundStyle(.primary)
            }
        } else {
            Image(systemName: "brain.fill")
                .font(.system(size: 14))
        }
    }

    /// Formats the remaining time as MM:SS or H:MM:SS depending on duration.
    private var timerText: String {
        let total = max(0, Int(sessionVM.timeRemaining))
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

// MARK: - Preview

#Preview {
    CompactTimerView()
        .environment(SessionViewModel())
}
