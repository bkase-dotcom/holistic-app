import SwiftUI

struct SensorHealthView: View {
    @Environment(\.dismiss) private var dismiss

    private let nanobots: [(name: String, system: String, image: String, status: String, count: String, color: Color)] = [
        ("Neural", "Central Nervous System", "NanobotNeural", "Nominal", "2.4M", HTheme.violet),
        ("Cardiovascular", "Circulatory System", "NanobotCardiovascular", "Nominal", "1.8M", HTheme.rust),
        ("Endocrine", "Hormonal Pathways", "NanobotEndocrine", "Nominal", "1.1M", HTheme.gold),
        ("Immune", "Lymphatic Network", "NanobotImmune", "Monitoring", "890K", HTheme.warm),
        ("Musculoskeletal", "Structural System", "NanobotMusculoskeletal", "Nominal", "1.6M", HTheme.copper),
    ]

    var body: some View {
        ZStack {
            HTheme.bg.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Sensor Health")
                                .font(HTheme.display(28))
                                .foregroundColor(HTheme.fg)
                            Text("Nanobot swarm diagnostics")
                                .font(HTheme.body(13))
                                .foregroundColor(HTheme.dim)
                        }
                        Spacer()
                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(HTheme.dim)
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.glass)
                    }

                    // Capsule hero image
                    capsuleHero

                    // Swarm overview
                    swarmOverview

                    // Nanobot system cards
                    SectionHeader(title: "Nanobot Systems", color: HTheme.copper)

                    ForEach(nanobots, id: \.name) { bot in
                        nanobotCard(bot)
                    }
                }
                .padding(.horizontal, HTheme.pagePadding)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Capsule Hero
    private var capsuleHero: some View {
        ZStack(alignment: .bottomLeading) {
            Image("PharmaceuticalCapsule")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))

            // Gradient overlay for text legibility
            LinearGradient(colors: [.clear, HTheme.bg.opacity(0.8)],
                           startPoint: .center, endPoint: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))

            VStack(alignment: .leading, spacing: 4) {
                Text("Holistic Capsule")
                    .font(HTheme.displayItalic(20))
                    .foregroundColor(HTheme.fg)
                Text("Ingested 72h ago · Fully dissolved · Swarm active")
                    .font(HTheme.body(11))
                    .foregroundColor(HTheme.dim)
            }
            .padding(HTheme.cardPadding)
        }
        .overlay(
            RoundedRectangle(cornerRadius: HTheme.cardRadius)
                .stroke(HTheme.borderColor, lineWidth: 1)
        )
    }

    // MARK: - Swarm Overview
    private var swarmOverview: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Swarm Status", color: HTheme.teal)

            HStack(spacing: HTheme.gridSpacing) {
                overviewStat(label: "Total Active", value: "7.7M", color: HTheme.teal)
                overviewStat(label: "Battery", value: "94%", color: HTheme.gold)
                overviewStat(label: "Uptime", value: "72h", color: HTheme.copper)
            }

            HStack(spacing: HTheme.gridSpacing) {
                overviewStat(label: "Signal", value: "Strong", color: HTheme.teal)
                overviewStat(label: "Temp", value: "36.8°C", color: HTheme.warm)
                overviewStat(label: "Errors", value: "0", color: HTheme.teal)
            }
        }
    }

    private func overviewStat(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(HTheme.label())
                .foregroundColor(HTheme.dim)
                .tracking(0.8)
            Text(value)
                .font(HTheme.display(20))
                .foregroundColor(color)
        }
        .padding(HTheme.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(HTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: HTheme.cardRadius)
                .stroke(color.opacity(0.06), lineWidth: 1)
        )
    }

    // MARK: - Nanobot Card
    private func nanobotCard(_ bot: (name: String, system: String, image: String, status: String, count: String, color: Color)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // SEM image
            Image(bot.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 160)
                .clipped()

            // Info
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(bot.name)
                        .font(HTheme.display(20))
                        .foregroundColor(bot.color)
                    Spacer()
                    Text(bot.status.uppercased())
                        .font(HTheme.label())
                        .foregroundColor(bot.color)
                        .tracking(0.8)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(bot.color.opacity(0.07))
                        .clipShape(Capsule())
                }

                Text(bot.system)
                    .font(HTheme.body(12))
                    .foregroundColor(HTheme.dim)

                HStack(spacing: 16) {
                    diagStat(label: "Count", value: bot.count)
                    diagStat(label: "Integrity", value: "99.7%")
                    diagStat(label: "Latency", value: "<2ms")
                }
            }
            .padding(HTheme.cardPadding)
        }
        .background(HTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: HTheme.cardRadius)
                .stroke(bot.color.opacity(0.06), lineWidth: 1)
        )
    }

    private func diagStat(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(.system(size: 9, weight: .medium, design: .rounded))
                .foregroundColor(HTheme.dim)
                .tracking(0.6)
            Text(value)
                .font(HTheme.body(13, weight: .medium))
                .foregroundColor(HTheme.fg)
        }
    }
}
