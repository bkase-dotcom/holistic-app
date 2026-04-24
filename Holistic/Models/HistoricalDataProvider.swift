import SwiftUI

struct HistoricalPeriodData {
    let insightTitle: String
    let insightBody: String
    let sparklines: [HistoricalSparkline]
    let profiles: [(label: String, pct: Int, color: Color)]
}

struct HistoricalSparkline: Identifiable {
    let id = UUID()
    let name: String
    let status: String
    let statusColor: Color
    let color: Color
    let dataPoints: [CGFloat]
}

enum HistoricalDataProvider {
    static func data(for period: String) -> HistoricalPeriodData {
        switch period {
        case "24h": return twentyFourHour
        case "7d":  return sevenDay
        case "30d": return thirtyDay
        case "90d": return ninetyDay
        default:    return sevenDay
        }
    }

    // MARK: - 24 Hour

    private static let twentyFourHour = HistoricalPeriodData(
        insightTitle: "Intraday rhythm detected",
        insightBody: "Neural coherence peaked between 9–11am (0.91) and again 8–9:30pm (0.87). Cortisol followed expected diurnal curve with a 2:30pm nadir. Cognitive load spiked at 3pm — correlates with calendar meeting density. Gut-brain axis synchrony was steady throughout.",
        sparklines: [
            HistoricalSparkline(name: "Neural Coherence", status: "Variable", statusColor: HTheme.gold,
                color: HTheme.violet,
                dataPoints: [0.4, 0.45, 0.5, 0.6, 0.75, 0.88, 0.91, 0.85, 0.78, 0.65, 0.55, 0.5,
                             0.48, 0.52, 0.58, 0.62, 0.7, 0.78, 0.87, 0.82, 0.7, 0.55, 0.45, 0.4]),
            HistoricalSparkline(name: "Cardiovascular", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.rust,
                dataPoints: [0.5, 0.48, 0.52, 0.55, 0.58, 0.6, 0.62, 0.65, 0.6, 0.55, 0.58, 0.62,
                             0.65, 0.7, 0.68, 0.62, 0.58, 0.55, 0.5, 0.48, 0.45, 0.42, 0.4, 0.38]),
            HistoricalSparkline(name: "Endocrine", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.gold,
                dataPoints: [0.85, 0.8, 0.72, 0.65, 0.6, 0.58, 0.55, 0.5, 0.45, 0.4, 0.35, 0.32,
                             0.3, 0.32, 0.35, 0.38, 0.4, 0.42, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7]),
            HistoricalSparkline(name: "Gut-Brain Axis", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.teal,
                dataPoints: [0.5, 0.52, 0.54, 0.55, 0.56, 0.58, 0.55, 0.53, 0.52, 0.54, 0.56, 0.58,
                             0.6, 0.58, 0.55, 0.53, 0.55, 0.57, 0.58, 0.56, 0.54, 0.52, 0.5, 0.48]),
            HistoricalSparkline(name: "Musculoskeletal", status: "Variable", statusColor: HTheme.gold,
                color: HTheme.copper,
                dataPoints: [0.7, 0.68, 0.65, 0.6, 0.55, 0.5, 0.48, 0.45, 0.42, 0.4, 0.42, 0.45,
                             0.5, 0.55, 0.6, 0.65, 0.7, 0.72, 0.75, 0.78, 0.8, 0.82, 0.85, 0.87]),
            HistoricalSparkline(name: "Immune Baseline", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.warm,
                dataPoints: [0.6, 0.6, 0.58, 0.58, 0.6, 0.62, 0.6, 0.58, 0.6, 0.62, 0.6, 0.58,
                             0.6, 0.62, 0.6, 0.58, 0.6, 0.62, 0.64, 0.62, 0.6, 0.58, 0.6, 0.6]),
        ],
        profiles: [
            ("Analytical", 34, HTheme.violet),
            ("Intuitive", 29, HTheme.teal),
            ("Relational", 18, HTheme.warm),
            ("Ecological", 12, HTheme.gold),
            ("Contemplative", 7, HTheme.copper),
        ]
    )

    // MARK: - 7 Day

    private static let sevenDay = HistoricalPeriodData(
        insightTitle: "Pattern detected",
        insightBody: "Neural coherence peaks 9–11am and 8–10pm. Cortisol-to-melatonin crossover shifted 22 min earlier than previous 30-day average. Gut-brain axis shows improved synchrony after dietary adjustment on day 4.",
        sparklines: [
            HistoricalSparkline(name: "Neural Coherence", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.violet,
                dataPoints: [0.55, 0.58, 0.6, 0.62, 0.58, 0.55, 0.6, 0.65, 0.62, 0.6, 0.58, 0.62,
                             0.65, 0.68, 0.65, 0.62, 0.6, 0.58, 0.62, 0.65, 0.62]),
            HistoricalSparkline(name: "Cardiovascular", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.rust,
                dataPoints: [0.5, 0.52, 0.55, 0.53, 0.5, 0.52, 0.55, 0.58, 0.55, 0.52, 0.5, 0.52,
                             0.55, 0.58, 0.55, 0.53, 0.5, 0.52, 0.55, 0.53, 0.52]),
            HistoricalSparkline(name: "Endocrine", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.gold,
                dataPoints: [0.5, 0.48, 0.5, 0.52, 0.55, 0.52, 0.5, 0.48, 0.5, 0.52, 0.55, 0.52,
                             0.5, 0.48, 0.5, 0.52, 0.55, 0.52, 0.5, 0.48, 0.5]),
            HistoricalSparkline(name: "Gut-Brain Axis", status: "Improving", statusColor: HTheme.teal,
                color: HTheme.teal,
                dataPoints: [0.35, 0.38, 0.4, 0.42, 0.45, 0.48, 0.5, 0.52, 0.55, 0.58, 0.6, 0.62,
                             0.6, 0.62, 0.65, 0.68, 0.7, 0.68, 0.7, 0.72, 0.7]),
            HistoricalSparkline(name: "Musculoskeletal", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.copper,
                dataPoints: [0.6, 0.62, 0.6, 0.58, 0.6, 0.62, 0.65, 0.62, 0.6, 0.58, 0.6, 0.62,
                             0.65, 0.62, 0.6, 0.62, 0.65, 0.62, 0.6, 0.62, 0.6]),
            HistoricalSparkline(name: "Immune Baseline", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.warm,
                dataPoints: [0.55, 0.55, 0.58, 0.58, 0.6, 0.58, 0.55, 0.58, 0.6, 0.58, 0.55, 0.55,
                             0.58, 0.6, 0.58, 0.55, 0.55, 0.58, 0.6, 0.58, 0.58]),
        ],
        profiles: [
            ("Analytical", 35, HTheme.violet),
            ("Intuitive", 28, HTheme.teal),
            ("Relational", 18, HTheme.warm),
            ("Ecological", 12, HTheme.gold),
            ("Contemplative", 7, HTheme.copper),
        ]
    )

    // MARK: - 30 Day

    private static let thirtyDay = HistoricalPeriodData(
        insightTitle: "Monthly convergence trend",
        insightBody: "Immune baseline strengthened 12% since day 8, correlating with consistent sleep debt reduction. Musculoskeletal recovery shows a declining trend after increased training load in week 3. Cortisol variability narrowed — stress resilience improving. Neural coherence monthly average rose from 0.79 to 0.84.",
        sparklines: [
            HistoricalSparkline(name: "Neural Coherence", status: "Improving", statusColor: HTheme.teal,
                color: HTheme.violet,
                dataPoints: [0.42, 0.44, 0.48, 0.5, 0.48, 0.52, 0.55, 0.54, 0.58, 0.6, 0.58, 0.62,
                             0.6, 0.62, 0.65, 0.64, 0.66, 0.68, 0.65, 0.68, 0.7, 0.68, 0.72, 0.7,
                             0.72, 0.74, 0.72, 0.75, 0.74, 0.76]),
            HistoricalSparkline(name: "Cardiovascular", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.rust,
                dataPoints: [0.5, 0.52, 0.55, 0.53, 0.5, 0.48, 0.5, 0.52, 0.55, 0.53, 0.55, 0.58,
                             0.55, 0.52, 0.5, 0.52, 0.55, 0.58, 0.55, 0.52, 0.55, 0.58, 0.55, 0.52,
                             0.55, 0.58, 0.55, 0.52, 0.55, 0.55]),
            HistoricalSparkline(name: "Endocrine", status: "Improving", statusColor: HTheme.teal,
                color: HTheme.gold,
                dataPoints: [0.4, 0.42, 0.44, 0.42, 0.45, 0.48, 0.46, 0.48, 0.5, 0.52, 0.5, 0.52,
                             0.55, 0.53, 0.55, 0.58, 0.56, 0.58, 0.6, 0.58, 0.6, 0.62, 0.6, 0.62,
                             0.64, 0.62, 0.65, 0.64, 0.66, 0.65]),
            HistoricalSparkline(name: "Gut-Brain Axis", status: "Improving", statusColor: HTheme.teal,
                color: HTheme.teal,
                dataPoints: [0.3, 0.32, 0.35, 0.38, 0.4, 0.42, 0.45, 0.48, 0.5, 0.52, 0.55, 0.58,
                             0.6, 0.58, 0.6, 0.62, 0.65, 0.68, 0.7, 0.68, 0.7, 0.72, 0.7, 0.72,
                             0.74, 0.72, 0.74, 0.75, 0.74, 0.76]),
            HistoricalSparkline(name: "Musculoskeletal", status: "Declining", statusColor: HTheme.rust,
                color: HTheme.copper,
                dataPoints: [0.75, 0.74, 0.72, 0.7, 0.72, 0.7, 0.68, 0.65, 0.62, 0.6, 0.58, 0.55,
                             0.52, 0.5, 0.48, 0.5, 0.48, 0.45, 0.42, 0.44, 0.42, 0.4, 0.42, 0.44,
                             0.42, 0.4, 0.42, 0.44, 0.45, 0.44]),
            HistoricalSparkline(name: "Immune Baseline", status: "Improving", statusColor: HTheme.teal,
                color: HTheme.warm,
                dataPoints: [0.35, 0.38, 0.4, 0.38, 0.4, 0.42, 0.44, 0.45, 0.48, 0.5, 0.48, 0.5,
                             0.52, 0.55, 0.55, 0.58, 0.6, 0.58, 0.6, 0.62, 0.6, 0.62, 0.64, 0.65,
                             0.65, 0.68, 0.68, 0.7, 0.7, 0.72]),
        ],
        profiles: [
            ("Analytical", 32, HTheme.violet),
            ("Intuitive", 30, HTheme.teal),
            ("Relational", 19, HTheme.warm),
            ("Ecological", 13, HTheme.gold),
            ("Contemplative", 6, HTheme.copper),
        ]
    )

    // MARK: - 90 Day

    private static let ninetyDay = HistoricalPeriodData(
        insightTitle: "Quarterly optimization summary",
        insightBody: "Since capsule ingestion 90 days ago, all six primary systems show net positive trajectories. Neural coherence improved 18% (0.68 → 0.84). Immune baseline crossed into the 'enhanced' range at day 62. Gut-brain synchrony is the strongest gain (+34%). Musculoskeletal recovery rebounded after a week-3 training overload. Overall system harmony index: 0.81 — top 12th percentile.",
        sparklines: [
            HistoricalSparkline(name: "Neural Coherence", status: "Improving", statusColor: HTheme.teal,
                color: HTheme.violet,
                dataPoints: [0.28, 0.32, 0.35, 0.38, 0.4, 0.42, 0.45, 0.48, 0.5, 0.52, 0.55, 0.56,
                             0.58, 0.6, 0.58, 0.62, 0.64, 0.65, 0.66, 0.68, 0.66, 0.68, 0.7, 0.72,
                             0.72, 0.74, 0.75, 0.76, 0.78, 0.8]),
            HistoricalSparkline(name: "Cardiovascular", status: "Improving", statusColor: HTheme.teal,
                color: HTheme.rust,
                dataPoints: [0.45, 0.46, 0.48, 0.5, 0.48, 0.5, 0.52, 0.54, 0.52, 0.54, 0.56, 0.55,
                             0.56, 0.58, 0.6, 0.58, 0.6, 0.62, 0.6, 0.62, 0.64, 0.62, 0.64, 0.65,
                             0.66, 0.68, 0.68, 0.7, 0.7, 0.72]),
            HistoricalSparkline(name: "Endocrine", status: "Improving", statusColor: HTheme.teal,
                color: HTheme.gold,
                dataPoints: [0.3, 0.32, 0.35, 0.38, 0.4, 0.42, 0.44, 0.45, 0.48, 0.5, 0.52, 0.54,
                             0.55, 0.56, 0.58, 0.6, 0.58, 0.6, 0.62, 0.64, 0.62, 0.64, 0.65, 0.66,
                             0.68, 0.68, 0.7, 0.7, 0.72, 0.72]),
            HistoricalSparkline(name: "Gut-Brain Axis", status: "Improving", statusColor: HTheme.teal,
                color: HTheme.teal,
                dataPoints: [0.2, 0.22, 0.25, 0.28, 0.3, 0.32, 0.35, 0.38, 0.4, 0.42, 0.45, 0.48,
                             0.5, 0.52, 0.55, 0.58, 0.6, 0.62, 0.64, 0.65, 0.68, 0.7, 0.72, 0.74,
                             0.75, 0.76, 0.78, 0.78, 0.8, 0.82]),
            HistoricalSparkline(name: "Musculoskeletal", status: "Stable", statusColor: HTheme.teal,
                color: HTheme.copper,
                dataPoints: [0.5, 0.52, 0.55, 0.58, 0.6, 0.58, 0.55, 0.5, 0.45, 0.42, 0.4, 0.42,
                             0.45, 0.48, 0.5, 0.52, 0.55, 0.58, 0.6, 0.58, 0.6, 0.62, 0.64, 0.65,
                             0.66, 0.68, 0.68, 0.7, 0.7, 0.72]),
            HistoricalSparkline(name: "Immune Baseline", status: "Improving", statusColor: HTheme.teal,
                color: HTheme.warm,
                dataPoints: [0.25, 0.28, 0.3, 0.32, 0.34, 0.36, 0.38, 0.4, 0.42, 0.44, 0.46, 0.48,
                             0.5, 0.52, 0.54, 0.56, 0.58, 0.6, 0.62, 0.64, 0.65, 0.66, 0.68, 0.7,
                             0.72, 0.74, 0.75, 0.76, 0.78, 0.8]),
        ],
        profiles: [
            ("Analytical", 30, HTheme.violet),
            ("Intuitive", 31, HTheme.teal),
            ("Relational", 20, HTheme.warm),
            ("Ecological", 13, HTheme.gold),
            ("Contemplative", 6, HTheme.copper),
        ]
    )
}
