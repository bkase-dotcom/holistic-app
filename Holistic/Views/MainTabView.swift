import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    case historical = "Historical"
    case live = "Live"
    case predictions = "Predictions"
    case connections = "Connections"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .historical: return "clock.arrow.circlepath"
        case .live: return "waveform.path.ecg"
        case .predictions: return "sparkles"
        case .connections: return "link"
        }
    }

    var index: Int {
        switch self {
        case .historical: return 0
        case .live: return 1
        case .predictions: return 2
        case .connections: return 3
        }
    }
}

struct MainTabView: View {
    @ObservedObject var vm: VitalsViewModel
    @State private var selectedTab: Tab = .live
    @State private var previousTab: Tab = .live
    @Namespace private var tabNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GlassEffectContainer {
            ZStack {
                HTheme.bg.ignoresSafeArea()

                // Ambient glows — boosted for glass refraction
                Circle()
                    .fill(HTheme.teal)
                    .frame(width: 300, height: 300)
                    .blur(radius: 120)
                    .opacity(0.03)
                    .offset(x: 100, y: -200)
                    .ignoresSafeArea()

                Circle()
                    .fill(HTheme.copper)
                    .frame(width: 250, height: 250)
                    .blur(radius: 100)
                    .opacity(0.025)
                    .offset(x: -80, y: 250)
                    .ignoresSafeArea()

                // Content with directional transitions
                Group {
                    switch selectedTab {
                    case .historical:
                        HistoricalView(vm: vm)
                    case .live:
                        LiveView(vm: vm)
                    case .predictions:
                        PredictionsView()
                    case .connections:
                        ConnectionsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .id(selectedTab)
                .transition(tabTransition)
                .animation(
                    reduceMotion ? .easeOut(duration: 0.2) : .spring(response: 0.4, dampingFraction: 0.8),
                    value: selectedTab
                )
            }
            .safeAreaBar(edge: .bottom) {
                glassTabBar
            }
        }
    }

    // Directional slide based on tab index
    private var tabTransition: AnyTransition {
        let forward = selectedTab.index > previousTab.index
        return .asymmetric(
            insertion: .move(edge: forward ? .trailing : .leading).combined(with: .opacity),
            removal: .move(edge: forward ? .leading : .trailing).combined(with: .opacity)
        )
    }

    // MARK: - Liquid Glass Tab Bar
    private var glassTabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases) { tab in
                Button {
                    previousTab = selectedTab
                    HTheme.haptic(.light)
                    withAnimation(
                        reduceMotion
                            ? .easeOut(duration: 0.2)
                            : .spring(response: 0.35, dampingFraction: 0.72)
                    ) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 16, weight: .medium))
                            .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                            .animation(
                                reduceMotion ? nil : .spring(response: 0.3, dampingFraction: 0.6),
                                value: selectedTab
                            )
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(selectedTab == tab ? HTheme.warm : HTheme.dim)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background {
                        if selectedTab == tab {
                            Capsule()
                                .fill(.clear)
                                .glassEffect(.regular.tint(HTheme.warm.opacity(0.2)).interactive())
                                .matchedGeometryEffect(id: "activeTab", in: tabNamespace)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .glassEffect(.regular.tint(HTheme.dim.opacity(0.05)), in: .capsule)
        .padding(.horizontal, 10)
    }
}
