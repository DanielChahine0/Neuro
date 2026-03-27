import SwiftUI
import Charts

struct StatsView: View {
    @Bindable var viewModel: StatsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                periodPicker
                summaryCards
                focusChart
                distractionChart
                recentSessionsList
            }
            .padding()
        }
        .background(Color.neuroBackground)
        .onAppear {
            viewModel.loadStats()
        }
    }

    // MARK: - Period Picker

    private var periodPicker: some View {
        Picker("Period", selection: $viewModel.selectedPeriod) {
            ForEach(StatsViewModel.TimePeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.selectedPeriod) {
            viewModel.loadStats()
        }
    }

    // MARK: - Summary Cards

    private var summaryCards: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Focus Time",
                value: focusTimeForPeriod.formatted(),
                icon: "clock.fill"
            )
            StatCard(
                title: "Sessions",
                value: "\(viewModel.totalSessions)",
                icon: "target"
            )
            StatCard(
                title: "Avg Score",
                value: String(format: "%.0f%%", viewModel.averageFocusScore),
                icon: "chart.bar.fill",
                valueColor: viewModel.averageFocusScore.focusScoreColor
            )
            StatCard(
                title: "Streak",
                value: "\(viewModel.currentStreak)d",
                icon: "flame.fill",
                valueColor: viewModel.currentStreak > 0 ? .orange : .neuroMuted
            )
        }
    }

    private var focusTimeForPeriod: TimeInterval {
        switch viewModel.selectedPeriod {
        case .week: viewModel.weeklyFocusTime
        case .month: viewModel.monthlyFocusTime
        case .allTime: viewModel.monthlyFocusTime // best available
        }
    }

    // MARK: - Focus Chart

    private var focusChart: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Label("Daily Focus Hours", systemImage: "chart.bar.fill")
                    .font(.headline)
                    .foregroundStyle(.white)

                let data = viewModel.chartData()

                if data.isEmpty {
                    chartEmptyState
                } else {
                    Chart(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Hours", entry.hours)
                        )
                        .foregroundStyle(Color.neuroAccent.gradient)
                        .cornerRadius(4)
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { value in
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                                .foregroundStyle(Color.neuroMuted)
                            AxisGridLine()
                                .foregroundStyle(Color.neuroBorder)
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel {
                                if let hours = value.as(Double.self) {
                                    Text(String(format: "%.1fh", hours))
                                        .foregroundStyle(Color.neuroMuted)
                                }
                            }
                            AxisGridLine()
                                .foregroundStyle(Color.neuroBorder)
                        }
                    }
                    .chartPlotStyle { plotArea in
                        plotArea.background(Color.neuroSurface.opacity(0.5))
                    }
                    .frame(height: 200)
                }
            }
            .padding(4)
        }
        .groupBoxStyle(NeuroGroupBoxStyle())
    }

    // MARK: - Distraction Chart

    private var distractionChart: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Label("Distraction Trend", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
                    .foregroundStyle(.white)

                let data = viewModel.distractionChartData()

                if data.isEmpty {
                    chartEmptyState
                } else {
                    Chart(data, id: \.date) { entry in
                        LineMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Count", entry.count)
                        )
                        .foregroundStyle(Color.neuroWarning)
                        .interpolationMethod(.catmullRom)

                        AreaMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Count", entry.count)
                        )
                        .foregroundStyle(
                            .linearGradient(
                                colors: [Color.neuroWarning.opacity(0.3), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Count", entry.count)
                        )
                        .foregroundStyle(Color.neuroWarning)
                        .symbolSize(30)
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                                .foregroundStyle(Color.neuroMuted)
                            AxisGridLine()
                                .foregroundStyle(Color.neuroBorder)
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel()
                                .foregroundStyle(Color.neuroMuted)
                            AxisGridLine()
                                .foregroundStyle(Color.neuroBorder)
                        }
                    }
                    .chartPlotStyle { plotArea in
                        plotArea.background(Color.neuroSurface.opacity(0.5))
                    }
                    .frame(height: 150)
                }
            }
            .padding(4)
        }
        .groupBoxStyle(NeuroGroupBoxStyle())
    }

    private var chartEmptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.bar.xaxis")
                .font(.title2)
                .foregroundStyle(Color.neuroMuted)
            Text("No data for this period")
                .font(.subheadline)
                .foregroundStyle(Color.neuroMuted)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
    }

    // MARK: - Recent Sessions

    private var recentSessionsList: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Label("Recent Sessions", systemImage: "clock.arrow.circlepath")
                    .font(.headline)
                    .foregroundStyle(.white)

                if viewModel.recentSessions.isEmpty {
                    Text("No sessions yet. Start your first focus session!")
                        .font(.subheadline)
                        .foregroundStyle(Color.neuroMuted)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                } else {
                    ForEach(viewModel.recentSessions, id: \.id) { session in
                        SessionRow(session: session)
                        if session.id != viewModel.recentSessions.last?.id {
                            Divider()
                                .background(Color.neuroBorder)
                        }
                    }
                }
            }
            .padding(4)
        }
        .groupBoxStyle(NeuroGroupBoxStyle())
    }
}

// MARK: - Supporting Views

private struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var valueColor: Color = .white

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.neuroAccent)

            Text(value)
                .font(.title2.bold())
                .foregroundStyle(valueColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(title)
                .font(.caption)
                .foregroundStyle(Color.neuroMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.neuroSurface)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.neuroBorder, lineWidth: 1)
        )
    }
}

private struct SessionRow: View {
    let session: FocusSession

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(session.startDate, style: .date)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                Text(session.startDate, style: .time)
                    .font(.caption)
                    .foregroundStyle(Color.neuroMuted)
            }

            Spacer()

            Text(session.actualDuration.formatted())
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(Color.neuroMuted)

            Text(String(format: "%.0f%%", session.focusScore))
                .font(.caption.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(session.focusScore.focusScoreColor.opacity(0.2))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(session.focusScore.focusScoreColor.opacity(0.5), lineWidth: 1)
                )
        }
    }
}

// MARK: - Group Box Style

struct NeuroGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.content
        }
        .padding(12)
        .background(Color.neuroSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.neuroBorder, lineWidth: 1)
        )
    }
}

#Preview {
    // Preview requires a ModelContext; shown for structure reference only.
    Text("StatsView Preview")
        .frame(width: 400, height: 600)
}
