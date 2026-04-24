import SwiftUI

struct PredictionsView: View {
    private let predictions: [Prediction] = [
        Prediction(timeframe: "Next 2 hours", title: "Energy dip incoming",
                   body: "Cortisol declining, musculoskeletal recovery peaking. Good window for contemplative work rather than analytical tasks.",
                   confidence: 89, color: "gold"),
        Prediction(timeframe: "This evening", title: "Deep sleep favorable",
                   body: "Melatonin onset 22 min earlier than last week. Maintain low cognitive load after 9pm for projected 1.8hr deep sleep.",
                   confidence: 76, color: "violet"),
        Prediction(timeframe: "Tomorrow AM", title: "Creative peak window",
                   body: "Neural coherence patterns predict highest creative state 9:30–11am. Gut-brain and endocrine patterns support divergent thinking.",
                   confidence: 72, color: "teal"),
        Prediction(timeframe: "48 hours", title: "Immune system note",
                   body: "Inflammatory markers 8% above baseline. Not clinically significant. Moderate intensity movement recommended.",
                   confidence: 65, color: "rust"),
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Anticipated States", color: HTheme.gold)
                    .padding(.bottom, 4)

                ForEach(Array(predictions.enumerated()), id: \.element.id) { index, prediction in
                    PredictionCardView(prediction: prediction, index: index)
                }
            }
            .padding(.horizontal, HTheme.pagePadding)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
}

// MARK: - Prediction Card with confidence ring
struct PredictionCardView: View {
    let prediction: Prediction
    let index: Int
    @State private var ringProgress: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var accentColor: Color {
        switch prediction.color {
        case "gold": return HTheme.gold
        case "violet": return HTheme.violet
        case "teal": return HTheme.teal
        case "rust": return HTheme.rust
        default: return HTheme.warm
        }
    }

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 0) {
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(prediction.timeframe.uppercased())
                            .font(HTheme.label())
                            .foregroundColor(HTheme.dim)
                            .tracking(0.8)
                        Spacer()

                        // Confidence ring
                        ZStack {
                            Circle()
                                .stroke(accentColor.opacity(0.12), lineWidth: 2.5)
                            Circle()
                                .trim(from: 0, to: ringProgress)
                                .stroke(accentColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                                .rotationEffect(.degrees(-90))

                            Text("\(prediction.confidence)%")
                                .font(HTheme.body(9, weight: .medium))
                                .foregroundColor(accentColor)
                        }
                        .frame(width: 36, height: 36)
                    }

                    Text(prediction.title)
                        .font(HTheme.display(20))
                        .foregroundColor(HTheme.fg)

                    Text(prediction.body)
                        .font(HTheme.body(12))
                        .foregroundColor(HTheme.dim)
                        .lineSpacing(2)
                }
                .padding(HTheme.cardPadding)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(HTheme.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: HTheme.cardRadius)
                    .stroke(accentColor.opacity(0.06), lineWidth: 1)
            )
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(colors: [accentColor.opacity(0.8), accentColor.opacity(0.3)],
                                       startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 3)
                    .padding(.vertical, 8)
                    .padding(.leading, 4)
            }
        }
        .buttonStyle(PressableCardStyle())
        .onAppear {
            withAnimation(
                reduceMotion
                    ? .easeOut(duration: 0.3)
                    : .spring(response: 0.8, dampingFraction: 0.8).delay(0.15 * Double(index))
            ) {
                ringProgress = CGFloat(prediction.confidence) / 100.0
            }
        }
    }
}
