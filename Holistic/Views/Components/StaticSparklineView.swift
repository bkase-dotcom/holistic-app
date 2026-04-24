import SwiftUI

struct SparklinePath: Shape {
    let dataPoints: [CGFloat]
    var drawProgress: CGFloat = 1

    var animatableData: CGFloat {
        get { drawProgress }
        set { drawProgress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        guard dataPoints.count > 1 else { return Path() }

        let visibleCount = max(1, Int(CGFloat(dataPoints.count) * drawProgress))
        let stepX = rect.width / CGFloat(dataPoints.count - 1)

        var path = Path()
        for i in 0..<visibleCount {
            let x = CGFloat(i) * stepX
            let y = rect.height - (dataPoints[i] * rect.height * 0.85) - (rect.height * 0.075)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        return path
    }
}

struct StaticSparklineView: View {
    let dataPoints: [CGFloat]
    let color: Color
    var height: CGFloat = 30
    var lineWidth: CGFloat = 1.2

    @State private var drawProgress: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        SparklinePath(dataPoints: dataPoints, drawProgress: drawProgress)
            .stroke(color.opacity(0.5), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            .frame(height: height)
            .onAppear {
                withAnimation(
                    reduceMotion
                        ? .easeOut(duration: 0.2)
                        : .easeOut(duration: 0.8)
                ) {
                    drawProgress = 1
                }
            }
    }
}
