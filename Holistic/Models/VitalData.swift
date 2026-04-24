import SwiftUI

struct VitalData {
    var heartRate: Int = 72
    var hrv: Int = 48
    var bloodOxygen: Double = 98.2
    var coreTemp: Double = 98.4
    var systolic: Int = 118
    var diastolic: Int = 76
    var cortisol: Double = 12.3
    var melatonin: Double = 8.1
    var respiratoryRate: Int = 14
    var gutPh: Double = 6.8
    var immuneStatus: String = "Baseline"
    var muscleRecovery: Int = 87
    var cognitiveLoad: Int = 34
    var emotionalState: String = "Calm Focus"
    var neuralCoherence: Double = 0.82
    var sleepDebt: Double = 0.4
}

struct Prediction: Identifiable {
    let id = UUID()
    let timeframe: String
    let title: String
    let body: String
    let confidence: Int
    let color: String
}

// MARK: - Connection Category

enum ConnectionCategory: String, CaseIterable, Identifiable {
    case healthBiometrics = "Health & Biometrics"
    case smartHome = "Smart Home"
    case transportation = "Transportation"
    case workProductivity = "Work & Productivity"
    case finance = "Finance"
    case social = "Social"
    case entertainment = "Entertainment"
    case wellness = "Wellness"
    case education = "Education"
    case shopping = "Shopping"
    case governmentID = "Government & ID"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .healthBiometrics: return "heart.text.square"
        case .smartHome: return "house"
        case .transportation: return "car"
        case .workProductivity: return "briefcase"
        case .finance: return "banknote"
        case .social: return "person.2"
        case .entertainment: return "play.circle"
        case .wellness: return "leaf"
        case .education: return "book"
        case .shopping: return "bag"
        case .governmentID: return "person.text.rectangle"
        }
    }

    var color: Color {
        switch self {
        case .healthBiometrics: return HTheme.rust
        case .smartHome: return HTheme.teal
        case .transportation: return HTheme.copper
        case .workProductivity: return HTheme.gold
        case .finance: return HTheme.warm
        case .social: return HTheme.violet
        case .entertainment: return HTheme.teal
        case .wellness: return HTheme.gold
        case .education: return HTheme.violet
        case .shopping: return HTheme.copper
        case .governmentID: return HTheme.rust
        }
    }
}

// MARK: - Vital Status

enum VitalStatus: String {
    case optimal = "Optimal"
    case normal = "Normal"
    case elevated = "Elevated"
    case low = "Low"
    case watch = "Watch"

    var icon: String {
        switch self {
        case .optimal: return "checkmark.circle.fill"
        case .normal:  return "circle.fill"
        case .elevated, .watch: return "exclamationmark.triangle.fill"
        case .low:     return "arrow.down.circle.fill"
        }
    }

    var statusColor: Color {
        switch self {
        case .optimal: return HTheme.teal
        case .normal:  return HTheme.teal
        case .elevated: return HTheme.gold
        case .low:     return HTheme.gold
        case .watch:   return HTheme.rust
        }
    }
}

struct Connection: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let category: ConnectionCategory
    var isEnabled: Bool
}
