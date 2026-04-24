import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @StateObject private var vm = VitalsViewModel()

    var body: some View {
        ZStack {
            HTheme.bg.ignoresSafeArea()

            if showSplash {
                SplashView {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
            } else {
                MainTabView(vm: vm)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.96).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
    }
}
