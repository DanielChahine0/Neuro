import SwiftUI

// MARK: - CompactTimerView

/// Displayed inline in the macOS system menu bar.
/// Shows a brain icon when idle, or a countdown timer during an active session.
struct CompactTimerView: View {
    let isActive: Bool
    let timeRemaining: TimeInterval

    var body: some View {
        if isActive {
            HStack(spacing: 4) {
                Image(systemName: "brain.fill")
                    .font(.system(size: 12))

                Text(timerText)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .monospacedDigit()
            }
        } else {
            Image(systemName: "brain.fill")
                .font(.system(size: 14))
        }
    }

    private var timerText: String {
        let total = max(0, Int(timeRemaining))
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

#Preview {
    CompactTimerView(isActive: true, timeRemaining: 1500)
}
