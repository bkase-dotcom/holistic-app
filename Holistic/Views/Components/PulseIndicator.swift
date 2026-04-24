import SwiftUI

struct PulseIndicator: View {
    let color: Color
    var size: CGFloat = 8
    @State private var ripple = false
    @State private var boundaryPulse = false
    @State private var heartbeat = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            // Layer 1: Outer expanding ripple ring
            Circle()
                .stroke(color.opacity(0.35), lineWidth: 1)
                .frame(width: size * 2.5, height: size * 2.5)
                .scaleEffect(ripple ? 2.5 : 1)
                .opacity(ripple ? 0 : 0.6)
                .animation(
                    reduceMotion ? nil : .easeOut(duration: 2.0).repeatForever(autoreverses: false),
                    value: ripple
                )

            // Layer 2: Boundary ring — subtle opacity pulse
            Circle()
                .stroke(color.opacity(0.5), lineWidth: 1.2)
                .frame(width: size * 1.8, height: size * 1.8)
                .opacity(boundaryPulse ? 1 : 0.5)
                .animation(
                    reduceMotion ? nil : .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                    value: boundaryPulse
                )

            // Layer 3: Core heartbeat dot
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .shadow(color: color.opacity(0.6), radius: 4)
                .scaleEffect(heartbeat ? 1.0 : 0.8)
                .animation(
                    reduceMotion ? nil : .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                    value: heartbeat
                )
        }
        .frame(width: size * 3, height: size * 3)
        .onAppear {
            ripple = true
            boundaryPulse = true
            heartbeat = true
        }
    }
}
