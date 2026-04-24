import SwiftUI

struct LiveView: View {
    @ObservedObject var vm: VitalsViewModel
    @State private var showSensorHealth = false
    @State private var showThoughtDialogue = false
    @State private var waveBoost: CGFloat = 1.0
    @State private var scrollOffset: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let columns2 = [GridItem(.flexible(), spacing: HTheme.gridSpacing),
                            GridItem(.flexible(), spacing: HTheme.gridSpacing)]
    private let columns3 = [GridItem(.flexible(), spacing: HTheme.gridSpacing),
                            GridItem(.flexible(), spacing: HTheme.gridSpacing),
                            GridItem(.flexible(), spacing: HTheme.gridSpacing)]

    // Header compression: lerp from full to compressed
    private var headerScale: CGFloat {
        let progress = min(max(-scrollOffset / 80, 0), 1)
        return 1 - (progress * 0.15)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                // Scroll offset tracker
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ScrollOffsetKey.self,
                                    value: geo.frame(in: .named("liveScroll")).minY)
                }
                .frame(height: 0)

                // 1. Neural Link Status Bar
                neuralLinkBar
                    .padding(.bottom, 20)
                    .modifier(ScrollStaggerAppear(index: 0))

                // 2. Sensor Health shortcut
                sensorHealthCard
                    .padding(.bottom, 16)
                    .modifier(ScrollStaggerAppear(index: 1))

                // 3. Cardiovascular Hero
                cardiovascularHero
                    .padding(.bottom, 16)
                    .modifier(ScrollStaggerAppear(index: 2))

                // 4. Vitals Grid
                vitalsGrid
                    .padding(.bottom, 20)
                    .modifier(ScrollStaggerAppear(index: 3))

                // 5. Neural · Cognitive
                neuralCognitive
                    .padding(.bottom, 20)
                    .modifier(ScrollStaggerAppear(index: 4))

                // 6. Endocrine + Respiratory
                endocrineRespiratory
                    .padding(.bottom, 20)
                    .modifier(ScrollStaggerAppear(index: 5))

                // 7. Musculoskeletal + Immune + Gut
                bodySystemsRow
                    .padding(.bottom, 20)
                    .modifier(ScrollStaggerAppear(index: 6))

                // 8. Sleep
                sleepSection
                    .padding(.bottom, 100)
                    .modifier(ScrollStaggerAppear(index: 7))
            }
            .padding(.horizontal, HTheme.pagePadding)
            .padding(.top, 16)
        }
        .coordinateSpace(name: "liveScroll")
        .onPreferenceChange(ScrollOffsetKey.self) { scrollOffset = $0 }
        .onChange(of: vm.vitals.heartRate) { _, _ in
            guard !reduceMotion else { return }
            withAnimation(.spring(response: 0.3)) { waveBoost = 1.5 }
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) { waveBoost = 1.0 }
        }
        .sheet(isPresented: $showSensorHealth) {
            SensorHealthView()
        }
    }

    // MARK: - Sensor Health Card
    private var sensorHealthCard: some View {
        Button { showSensorHealth = true } label: {
            HStack(spacing: 12) {
                Image("CapsulePackaging")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Sensor Health")
                        .font(HTheme.body(13, weight: .medium))
                        .foregroundColor(HTheme.fg)
                    Text("7.7M nanobots active · All systems nominal")
                        .font(HTheme.body(11))
                        .foregroundColor(HTheme.dim)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(HTheme.dim)
            }
            .padding(HTheme.cardPadding)
            .background(HTheme.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: HTheme.cardRadius)
                    .stroke(HTheme.copper.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(PressableCardStyle())
    }

    // MARK: - Neural Link Status Bar (Liquid Glass — tappable)
    private var neuralLinkBar: some View {
        Button {
            HTheme.haptic(.medium)
            showThoughtDialogue = true
        } label: {
            HStack(spacing: 12) {
                PulseIndicator(color: HTheme.teal)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Neural Link Active")
                        .font(HTheme.body(12, weight: .medium))
                        .foregroundStyle(HTheme.teal)
                        .scaleEffect(headerScale, anchor: .leading)

                    Text("Thought-dialogue ready · Coh \(String(format: "%.2f", vm.vitals.neuralCoherence))")
                        .font(HTheme.body(10))
                        .foregroundStyle(HTheme.dim)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(HTheme.dim)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassEffect(.clear.tint(HTheme.teal.opacity(0.2)), in: .capsule)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showThoughtDialogue) {
            ThoughtDialogueView()
        }
    }

    // MARK: - Cardiovascular Hero
    private var cardiovascularHero: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                SectionHeader(title: "Cardiovascular", color: HTheme.rust)
                Spacer()
                HStack(spacing: 8) {
                    statusPill(.normal)
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        Text("\(vm.vitals.heartRate)")
                            .font(HTheme.display(32))
                            .foregroundColor(HTheme.rust)
                            .contentTransition(.numericText())
                        Text("bpm")
                            .font(HTheme.body(12))
                            .foregroundColor(HTheme.dim)
                    }
                }
            }

            WaveformView(color: HTheme.rust, amplitude: 12 * waveBoost, frequency: 0.08, speed: 3.0, lineWidth: 1.4, height: 44)
                .padding(HTheme.cardPadding)
                .background(HTheme.cardBg)
                .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: HTheme.cardRadius)
                        .stroke(HTheme.rust.opacity(0.06), lineWidth: 1)
                )
        }
    }

    // MARK: - Vitals Grid
    private var vitalsGrid: some View {
        LazyVGrid(columns: columns2, spacing: HTheme.gridSpacing) {
            VitalCard(label: "HRV", value: "\(vm.vitals.hrv)", unit: "ms", color: HTheme.rust, status: vm.vitals.hrv < 47 ? .low : .normal)
            VitalCard(label: "Blood O₂", value: String(format: "%.1f", vm.vitals.bloodOxygen), unit: "%", color: HTheme.rust, status: .optimal)
            VitalCard(label: "Blood Pressure", value: "\(vm.vitals.systolic)/\(vm.vitals.diastolic)", unit: "mmHg", color: HTheme.rust, status: vm.vitals.systolic >= 118 ? .elevated : .normal)
            VitalCard(label: "Core Temp", value: String(format: "%.1f", vm.vitals.coreTemp), unit: "°F", color: HTheme.warm, status: .normal)
        }
    }

    // MARK: - Neural · Cognitive
    private var neuralCognitive: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Neural · Cognitive", color: HTheme.violet)

            Button(action: {}) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("EMOTIONAL STATE")
                                .font(HTheme.label())
                                .foregroundColor(HTheme.dim)
                                .tracking(0.8)
                            Text(vm.vitals.emotionalState)
                                .font(HTheme.display(22))
                                .foregroundColor(HTheme.violet)
                            statusPill(.normal)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("COGNITIVE LOAD")
                                .font(HTheme.label())
                                .foregroundColor(HTheme.dim)
                                .tracking(0.8)
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text("\(vm.vitals.cognitiveLoad)")
                                    .font(HTheme.display(22))
                                    .foregroundColor(HTheme.violet)
                                    .contentTransition(.numericText())
                                Text("%")
                                    .font(HTheme.body(11))
                                    .foregroundColor(HTheme.dim)
                            }
                            statusPill(vm.vitals.cognitiveLoad > 40 ? .elevated : .normal)
                        }
                    }

                    WaveformView(color: HTheme.violet, amplitude: 8, frequency: 0.05, speed: 2.0, height: 28)
                }
                .padding(HTheme.cardPadding)
                .background(HTheme.cardBg)
                .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: HTheme.cardRadius)
                        .stroke(HTheme.violet.opacity(0.06), lineWidth: 1)
                )
            }
            .buttonStyle(PressableCardStyle())
        }
    }

    // MARK: - Endocrine + Respiratory
    private var endocrineRespiratory: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Endocrine · Respiratory", color: HTheme.gold)

            LazyVGrid(columns: columns2, spacing: HTheme.gridSpacing) {
                VitalCard(label: "Cortisol", value: String(format: "%.1f", vm.vitals.cortisol), unit: "μg/dL", color: HTheme.gold, status: vm.vitals.cortisol > 13.0 ? .elevated : .normal)
                VitalCard(label: "Resp Rate", value: "\(vm.vitals.respiratoryRate)", unit: "/min", color: HTheme.teal, showWave: true, status: .normal)
            }
        }
    }

    // MARK: - Body Systems Row
    private var bodySystemsRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Body Systems", color: HTheme.copper)

            LazyVGrid(columns: columns3, spacing: HTheme.gridSpacing) {
                VitalCard(label: "Muscle", value: "\(vm.vitals.muscleRecovery)", unit: "%", color: HTheme.copper, status: vm.vitals.muscleRecovery >= 90 ? .optimal : .normal)
                VitalCard(label: "Immune", value: vm.vitals.immuneStatus, unit: "", color: HTheme.warm, status: .normal)
                VitalCard(label: "Gut pH", value: String(format: "%.1f", vm.vitals.gutPh), unit: "", color: HTheme.teal, status: .normal)
            }
        }
    }

    // MARK: - Sleep
    private var sleepSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Sleep", color: HTheme.violet)

            LazyVGrid(columns: columns2, spacing: HTheme.gridSpacing) {
                VitalCard(label: "Sleep Debt", value: String(format: "%.1f", vm.vitals.sleepDebt), unit: "hrs", color: HTheme.violet, status: vm.vitals.sleepDebt < 0.5 ? .optimal : .normal)
                VitalCard(label: "Melatonin", value: String(format: "%.1f", vm.vitals.melatonin), unit: "pg/mL", color: HTheme.violet, status: .normal)
            }
        }
    }

    // MARK: - Status Pill Helper
    private func statusPill(_ status: VitalStatus) -> some View {
        HStack(spacing: 4) {
            Image(systemName: status.icon)
                .font(.system(size: 7))
                .foregroundColor(status.statusColor)
            Text(status.rawValue)
                .font(.system(size: 9, weight: .medium, design: .rounded))
                .foregroundColor(status.statusColor)
        }
    }
}

// MARK: - Per-Item Staggered Appear (uses .onAppear per element)
struct ScrollStaggerAppear: ViewModifier {
    let index: Int
    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared || reduceMotion ? 0 : 16)
            .onAppear {
                guard !appeared else { return }
                withAnimation(
                    reduceMotion
                        ? .easeOut(duration: 0.15)
                        : .spring(response: 0.5, dampingFraction: 0.8).delay(0.06 * Double(index))
                ) {
                    appeared = true
                }
            }
    }
}
