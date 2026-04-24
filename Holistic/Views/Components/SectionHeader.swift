import SwiftUI

struct SectionHeader: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title.uppercased())
            .font(HTheme.label())
            .foregroundColor(HTheme.dim)
            .tracking(1.2)
            .padding(.leading, 2)
            .padding(.bottom, 4)
    }
}
