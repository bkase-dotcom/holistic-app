import SwiftUI
import Combine

class VitalsViewModel: ObservableObject {
    @Published var vitals = VitalData()
    private var timer: Timer?

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.8, repeats: true) { [weak self] _ in
            self?.updateVitals()
        }
    }

    private func updateVitals() {
        withAnimation(.easeInOut(duration: 0.7)) {
            vitals.heartRate = Int.random(in: 70...76)
            vitals.hrv = Int.random(in: 46...54)
            vitals.bloodOxygen = Double(Int.random(in: 978...986)) / 10.0
            vitals.coreTemp = Double(Int.random(in: 982...986)) / 10.0
            vitals.cortisol = Double(Int.random(in: 115...135)) / 10.0
            vitals.respiratoryRate = Int.random(in: 13...16)
            vitals.cognitiveLoad = Int.random(in: 30...42)
            vitals.neuralCoherence = Double(Int.random(in: 78...88)) / 100.0
            vitals.muscleRecovery = Int.random(in: 84...92)
        }
    }

    deinit { timer?.invalidate() }
}
