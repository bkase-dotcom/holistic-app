import SwiftUI

struct SplashView: View {
    let onDismiss: () -> Void

    @State private var phase1 = false
    @State private var phase2 = false
    @State private var phase3 = false
    @State private var tapBreathing = false
    @State private var isDismissing = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            HTheme.bg.ignoresSafeArea()

            // Ambient glows
            Circle()
                .fill(HTheme.teal)
                .frame(width: 300, height: 300)
                .blur(radius: 120)
                .opacity(0.025)
                .offset(x: 120, y: -300)

            Circle()
                .fill(HTheme.copper)
                .frame(width: 250, height: 250)
                .blur(radius: 100)
                .opacity(0.02)
                .offset(x: -100, y: 300)

            VStack(spacing: 32) {
                Spacer()

                // Capsule shape — spring entrance
                RoundedRectangle(cornerRadius: 55)
                    .fill(
                        RadialGradient(
                            colors: [HTheme.teal.opacity(0.6), HTheme.copper.opacity(0.4), HTheme.copper.opacity(0.1)],
                            center: .center,
                            startRadius: 10,
                            endRadius: 120
                        )
                    )
                    .frame(width: 110, height: 190)
                    .shadow(color: HTheme.teal.opacity(0.15), radius: 40)
                    .shadow(color: HTheme.copper.opacity(0.1), radius: 60)
                    .opacity(phase1 ? 1 : 0)
                    .scaleEffect(phase1 ? 1 : 0.8)
                    .animation(
                        reduceMotion ? .easeOut(duration: 0.3) : .spring(response: 0.6, dampingFraction: 0.7),
                        value: phase1
                    )

                // Title — spring slide up
                Text("Holistic")
                    .font(HTheme.displayItalic(38))
                    .foregroundColor(HTheme.warm)
                    .opacity(phase2 ? 1 : 0)
                    .offset(y: phase2 ? 0 : 12)
                    .animation(
                        reduceMotion ? .easeOut(duration: 0.3) : .spring(response: 0.5, dampingFraction: 0.8),
                        value: phase2
                    )

                // Tagline — staggered lines
                VStack(spacing: 4) {
                    taglineLine("Millions of nanobots.", delay: 0)
                    taglineLine("Every body system.", delay: 0.1)
                    taglineLine("One complete picture.", delay: 0.2)
                }

                Spacer()

                // Tap to enter — breathing
                Text("TAP TO ENTER")
                    .font(HTheme.body(10, weight: .medium))
                    .foregroundColor(HTheme.dim)
                    .tracking(1.5)
                    .opacity(phase3 ? (tapBreathing ? 0.3 : 0.7) : 0)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: tapBreathing)
                    .animation(.easeOut(duration: 0.5), value: phase3)
                    .padding(.bottom, 60)
            }
        }
        // Dismiss: scale up 1.05 + fade
        .scaleEffect(isDismissing ? 1.05 : 1)
        .opacity(isDismissing ? 0 : 1)
        .contentShape(Rectangle())
        .onTapGesture {
            guard phase3, !isDismissing else { return }
            HTheme.haptic(.light)
            withAnimation(.easeOut(duration: 0.3)) {
                isDismissing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onDismiss()
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(200))
            phase1 = true
            try? await Task.sleep(for: .milliseconds(800))
            phase2 = true
            try? await Task.sleep(for: .milliseconds(600))
            phase3 = true
            tapBreathing = true
        }
    }

    private func taglineLine(_ text: String, delay: Double) -> some View {
        Text(text)
            .font(HTheme.body(13))
            .foregroundColor(HTheme.dim)
            .multilineTextAlignment(.center)
            .opacity(phase3 ? 1 : 0)
            .offset(y: phase3 ? 0 : 6)
            .animation(
                reduceMotion
                    ? .easeOut(duration: 0.3).delay(delay)
                    : .spring(response: 0.5, dampingFraction: 0.8).delay(delay),
                value: phase3
            )
    }
}
