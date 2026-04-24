import SwiftUI

struct HistoricalView: View {
    @ObservedObject var vm: VitalsViewModel
    @State private var selectedPeriod = "7d"
    @Namespace private var periodNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let periods = ["24h", "7d", "30d", "90d"]

    private var periodData: HistoricalPeriodData {
        HistoricalDataProvider.data(for: selectedPeriod)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // 1. Period Selector
                periodSelector
                    .padding(.bottom, 4)

                // 2. Pattern Insight Card
                patternInsight
                    .id("insight-\(selectedPeriod)")
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))

                // 3. Sparklines
                ForEach(periodData.sparklines) { item in
                    sparklineCard(item: item)
                }
                .id("sparklines-\(selectedPeriod)")
                .transition(.opacity)

                // 4. Epistemological Profile
                epistemologicalProfile
                    .id("profile-\(selectedPeriod)")
                    .transition(.opacity)
                    .padding(.bottom, 100)
            }
            .padding(.horizontal, HTheme.pagePadding)
            .padding(.top, 16)
            .animation(
                reduceMotion ? .easeOut(duration: 0.2) : .spring(response: 0.5, dampingFraction: 0.8),
                value: selectedPeriod
            )
        }
    }

    // MARK: - Period Selector with matchedGeometryEffect
    private var periodSelector: some View {
        HStack(spacing: 8) {
            ForEach(periods, id: \.self) { period in
                Text(period)
                    .font(HTheme.body(12, weight: .medium))
                    .foregroundColor(selectedPeriod == period ? HTheme.bg : HTheme.dim)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background {
                        if selectedPeriod == period {
                            Capsule()
                                .fill(HTheme.warm)
                                .matchedGeometryEffect(id: "periodBg", in: periodNamespace)
                        } else {
                            Capsule()
                                .fill(HTheme.cardBg)
                        }
                    }
                    .onTapGesture {
                        HTheme.haptic(.light)
                        withAnimation(
                            reduceMotion
                                ? .easeOut(duration: 0.2)
                                : .spring(response: 0.4, dampingFraction: 0.75)
                        ) {
                            selectedPeriod = period
                        }
                    }
            }
            Spacer()
        }
    }

    // MARK: - Pattern Insight
    private var patternInsight: some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 8) {
                Text(periodData.insightTitle)
                    .font(HTheme.displayItalic(20))
                    .foregroundColor(HTheme.fg)

                Text(periodData.insightBody)
                    .font(HTheme.body(13))
                    .foregroundColor(HTheme.dim)
                    .lineSpacing(3)
            }
            .padding(HTheme.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(colors: [HTheme.violet.opacity(0.04), HTheme.teal.opacity(0.04)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: HTheme.cardRadius)
                    .stroke(HTheme.violet.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(PressableCardStyle())
    }

    // MARK: - Sparkline Card (Static)
    private func sparklineCard(item: HistoricalSparkline) -> some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.name.uppercased())
                        .font(HTheme.label())
                        .foregroundColor(HTheme.dim)
                        .tracking(0.8)
                    Spacer()
                    Text(item.status)
                        .font(HTheme.body(11, weight: .medium))
                        .foregroundColor(item.statusColor)
                }

                StaticSparklineView(
                    dataPoints: item.dataPoints,
                    color: item.color,
                    height: 30
                )
            }
            .padding(HTheme.cardPadding)
            .background(HTheme.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: HTheme.cardRadius)
                    .stroke(item.color.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(PressableCardStyle())
    }

    // MARK: - Epistemological Profile with pill cascade
    private var epistemologicalProfile: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Auto-Detected Epistemological Profile", color: HTheme.violet)

            Text("Derived from 72 hours of neural pattern observation. Reflects dominant modes of engaging with information and environment.")
                .font(HTheme.body(12))
                .foregroundColor(HTheme.dim)
                .lineSpacing(2)

            FlowLayout(spacing: 8) {
                ForEach(Array(periodData.profiles.enumerated()), id: \.element.label) { index, profile in
                    EpistPill(profile: profile, index: index)
                }
            }
        }
        .padding(HTheme.cardPadding)
        .background(HTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: HTheme.cardRadius)
                .stroke(HTheme.violet.opacity(0.06), lineWidth: 1)
        )
    }
}

// MARK: - Epistemological Pill with cascade animation
struct EpistPill: View {
    let profile: (label: String, pct: Int, color: Color)
    let index: Int
    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Text("\(profile.label) \(profile.pct)%")
            .font(HTheme.body(11, weight: .medium))
            .foregroundColor(profile.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(profile.color.opacity(0.07))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(profile.color.opacity(0.1), lineWidth: 1)
            )
            .scaleEffect(appeared ? 1 : 0)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                guard !appeared else { return }
                withAnimation(
                    reduceMotion
                        ? .easeOut(duration: 0.15)
                        : .spring(response: 0.5, dampingFraction: 0.7).delay(0.08 * Double(index))
                ) {
                    appeared = true
                }
            }
    }
}

// MARK: - Flow Layout for pills
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: ProposedViewSize(width: bounds.width, height: bounds.height), subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x - spacing)
        }

        return (CGSize(width: maxX, height: y + rowHeight), positions)
    }
}
