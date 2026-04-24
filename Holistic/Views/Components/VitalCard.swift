import SwiftUI

struct VitalCard: View {
    let label: String
    let value: String
    let unit: String
    let color: Color
    var subtitle: String? = nil
    var showWave: Bool = false
    var status: VitalStatus? = nil

    var body: some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label.uppercased())
                    .font(HTheme.label())
                    .foregroundColor(HTheme.dim)
                    .tracking(0.8)

                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text(value)
                        .font(HTheme.display(26))
                        .foregroundColor(color)
                        .contentTransition(.numericText())
                    if !unit.isEmpty {
                        Text(unit)
                            .font(HTheme.body(11))
                            .foregroundColor(HTheme.dim)
                    }
                }

                if let sub = subtitle {
                    Text(sub)
                        .font(HTheme.body(10))
                        .foregroundColor(HTheme.dim.opacity(0.5))
                }

                if let status {
                    HStack(spacing: 4) {
                        Image(systemName: status.icon)
                            .font(.system(size: 7))
                            .foregroundColor(status.statusColor)
                        Text(status.rawValue)
                            .font(.system(size: 9, weight: .medium, design: .rounded))
                            .foregroundColor(status.statusColor)
                    }
                    .padding(.top, 2)
                }

                if showWave {
                    WaveformView(color: color, amplitude: 6, height: 22)
                        .padding(.top, 4)
                }
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
        .buttonStyle(PressableCardStyle())
    }
}
