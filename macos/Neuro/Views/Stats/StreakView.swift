import SwiftUI

struct StreakView: View {
    let currentStreak: Int
    let longestStreak: Int
    let weeklyActivity: [Bool]

    var body: some View {
        VStack(spacing: 16) {
            // Large streak display
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(currentStreak > 0 ? .orange : Color.neuroMuted)

                    Text("\(currentStreak)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

                Text("day streak")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.neuroMuted)
            }

            // Longest streak comparison
            if longestStreak > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.neuroAccent)
                    Text("Best: \(longestStreak) days")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.neuroMuted)
                }
            }

            // Weekly activity grid
            VStack(spacing: 8) {
                Text("THIS WEEK")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color.neuroMuted)

                HStack(spacing: 8) {
                    ForEach(0..<7, id: \.self) { index in
                        let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]
                        let hasActivity = index < weeklyActivity.count ? weeklyActivity[index] : false

                        VStack(spacing: 4) {
                            Circle()
                                .fill(hasActivity ? Color.neuroAccent : Color.neuroBorder)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    hasActivity
                                        ? Image(systemName: "checkmark")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundStyle(.white)
                                        : nil
                                )

                            Text(dayLabels[index])
                                .font(.system(size: 9, weight: .medium))
                                .foregroundStyle(Color.neuroMuted)
                        }
                    }
                }
            }

            // Motivational message
            Text(motivationalMessage)
                .font(.system(size: 12))
                .foregroundStyle(Color.neuroMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(16)
        .background(Color.neuroSurface, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.neuroBorder, lineWidth: 1)
        )
    }

    private var motivationalMessage: String {
        switch currentStreak {
        case 0:
            return "Start a session to begin your streak!"
        case 1...6:
            return "Keep going! Build that consistency."
        case 7...13:
            return "A full week! You're building a habit."
        case 14...29:
            return "Two weeks strong! Impressive dedication."
        case 30...59:
            return "A month of focus! You're unstoppable."
        case 60...99:
            return "60+ days! Elite focus discipline."
        default:
            return "100+ days! You're a focus legend."
        }
    }
}

#Preview {
    StreakView(
        currentStreak: 12,
        longestStreak: 24,
        weeklyActivity: [true, true, false, true, true, false, false]
    )
    .frame(width: 300)
    .padding()
    .background(Color.neuroBackground)
}
