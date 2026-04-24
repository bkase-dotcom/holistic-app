import SwiftUI

struct WaveformView: View {
    let color: Color
    var amplitude: CGFloat = 10
    var frequency: CGFloat = 0.07
    var speed: CGFloat = 2.5
    var lineWidth: CGFloat = 1.2
    var height: CGFloat = 36

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate * Double(speed)
                var path = Path()
                for x in stride(from: 0, to: size.width, by: 1) {
                    let normalizedX = x / size.width * .pi * 2 * 8
                    let y = size.height / 2
                        + sin(normalizedX * CGFloat(frequency) * 10 + CGFloat(time)) * amplitude
                        + sin(normalizedX * CGFloat(frequency) * 21 + CGFloat(time) * 0.6) * (amplitude * 0.35)
                    if x == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
                context.opacity = 0.5
                context.stroke(path, with: .color(color), lineWidth: lineWidth)
            }
        }
        .frame(height: height)
    }
}
