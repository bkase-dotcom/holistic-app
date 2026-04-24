import Foundation

// MARK: - Calibration

struct CalibrationPrompt: Identifiable {
    let id = UUID()
    let category: String
    let instruction: String
    let targetWord: String
}

enum CalibrationData {
    static let prompts: [CalibrationPrompt] = [
        // Basic Words
        CalibrationPrompt(category: "Basic Communication", instruction: "Think the word:", targetWord: "Hello"),
        CalibrationPrompt(category: "Basic Communication", instruction: "Think the word:", targetWord: "Yes"),
        CalibrationPrompt(category: "Basic Communication", instruction: "Think the word:", targetWord: "No"),
        CalibrationPrompt(category: "Basic Communication", instruction: "Think the word:", targetWord: "Stop"),
        CalibrationPrompt(category: "Basic Communication", instruction: "Think the word:", targetWord: "Help"),
        CalibrationPrompt(category: "Basic Communication", instruction: "Think the word:", targetWord: "Go"),

        // Emotions
        CalibrationPrompt(category: "Emotional Mapping", instruction: "Feel and think:", targetWord: "Happy"),
        CalibrationPrompt(category: "Emotional Mapping", instruction: "Feel and think:", targetWord: "Calm"),
        CalibrationPrompt(category: "Emotional Mapping", instruction: "Feel and think:", targetWord: "Alert"),
        CalibrationPrompt(category: "Emotional Mapping", instruction: "Feel and think:", targetWord: "Tired"),

        // Actions
        CalibrationPrompt(category: "Action Intent", instruction: "Intend the action:", targetWord: "Open"),
        CalibrationPrompt(category: "Action Intent", instruction: "Intend the action:", targetWord: "Close"),
        CalibrationPrompt(category: "Action Intent", instruction: "Intend the action:", targetWord: "Next"),
        CalibrationPrompt(category: "Action Intent", instruction: "Intend the action:", targetWord: "Back"),
        CalibrationPrompt(category: "Action Intent", instruction: "Intend the action:", targetWord: "Send"),

        // Phrases
        CalibrationPrompt(category: "Phrase Recognition", instruction: "Think the phrase:", targetWord: "I agree"),
        CalibrationPrompt(category: "Phrase Recognition", instruction: "Think the phrase:", targetWord: "Tell me more"),
        CalibrationPrompt(category: "Phrase Recognition", instruction: "Think the phrase:", targetWord: "Not now"),
        CalibrationPrompt(category: "Phrase Recognition", instruction: "Think the phrase:", targetWord: "Thank you"),
    ]
}

// MARK: - Thought Dialogue

enum ThoughtMessageSender: String {
    case user = "Your Thought"
    case holistic = "Holistic"
}

struct ThoughtMessage: Identifiable {
    let id = UUID()
    let sender: ThoughtMessageSender
    let content: String
    let timestamp: Date
}

struct ThoughtConversation: Identifiable {
    let id = UUID()
    let title: String
    let messages: [ThoughtMessage]
}

// MARK: - Demo Conversations

enum ThoughtDialogueDemoData {
    static var conversations: [ThoughtConversation] {
        let cal = Calendar.current
        let now = Date()

        return [
            // Today — morning energy check-in
            ThoughtConversation(title: "Today, 9:14 AM", messages: [
                ThoughtMessage(sender: .user, content: "What's my energy like right now?",
                    timestamp: cal.date(bySettingHour: 9, minute: 14, second: 0, of: now)!),
                ThoughtMessage(sender: .holistic, content: "Your cortisol is at a natural morning peak. Neural coherence is 0.84 — this is an excellent window for analytical work. Cardiovascular system is well-rested and HRV is above your 7-day average.",
                    timestamp: cal.date(bySettingHour: 9, minute: 14, second: 3, of: now)!),
                ThoughtMessage(sender: .user, content: "Schedule deep work",
                    timestamp: cal.date(bySettingHour: 9, minute: 15, second: 0, of: now)!),
                ThoughtMessage(sender: .holistic, content: "Done. I've blocked your calendar from 9:30 to 11:00 AM and activated Focus Mode. I'll monitor cognitive load and alert you if fatigue sets in early. Your Hue lights are set to 4000K for concentration.",
                    timestamp: cal.date(bySettingHour: 9, minute: 15, second: 2, of: now)!),
            ]),

            // Yesterday — winding down difficulty
            ThoughtConversation(title: "Yesterday, 8:42 PM", messages: [
                ThoughtMessage(sender: .user, content: "Having trouble winding down",
                    timestamp: cal.date(byAdding: .day, value: -1, to: cal.date(bySettingHour: 20, minute: 42, second: 0, of: now)!)!),
                ThoughtMessage(sender: .holistic, content: "Your cortisol-to-melatonin crossover is delayed by 18 minutes tonight. I've dimmed your Hue lights to 2700K and lowered Eight Sleep Pod temperature by 1°. Consider avoiding screens for the next 20 minutes.",
                    timestamp: cal.date(byAdding: .day, value: -1, to: cal.date(bySettingHour: 20, minute: 42, second: 3, of: now)!)!),
                ThoughtMessage(sender: .user, content: "Play something calming",
                    timestamp: cal.date(byAdding: .day, value: -1, to: cal.date(bySettingHour: 20, minute: 43, second: 0, of: now)!)!),
                ThoughtMessage(sender: .holistic, content: "Playing 'Evening Ambient' on Apple Music — selected based on your relaxation-response patterns. Your melatonin onset is now tracking closer to baseline. Projected deep sleep: 1.6 hours.",
                    timestamp: cal.date(byAdding: .day, value: -1, to: cal.date(bySettingHour: 20, minute: 43, second: 4, of: now)!)!),
                ThoughtMessage(sender: .user, content: "Thank you",
                    timestamp: cal.date(byAdding: .day, value: -1, to: cal.date(bySettingHour: 20, minute: 44, second: 0, of: now)!)!),
                ThoughtMessage(sender: .holistic, content: "Of course. I'll continue monitoring your transition to sleep. Goodnight.",
                    timestamp: cal.date(byAdding: .day, value: -1, to: cal.date(bySettingHour: 20, minute: 44, second: 2, of: now)!)!),
            ]),

            // 2 days ago — gut discomfort
            ThoughtConversation(title: "2 Days Ago, 2:15 PM", messages: [
                ThoughtMessage(sender: .user, content: "Stomach feels off",
                    timestamp: cal.date(byAdding: .day, value: -2, to: cal.date(bySettingHour: 14, minute: 15, second: 0, of: now)!)!),
                ThoughtMessage(sender: .holistic, content: "I'm seeing a gut pH shift to 7.1, slightly above your baseline of 6.8. Immune markers are normal — no inflammatory response detected. This correlates with the new supplement you started yesterday. I'd recommend waiting 48 hours before adjusting.",
                    timestamp: cal.date(byAdding: .day, value: -2, to: cal.date(bySettingHour: 14, minute: 15, second: 4, of: now)!)!),
                ThoughtMessage(sender: .user, content: "Set a reminder to check",
                    timestamp: cal.date(byAdding: .day, value: -2, to: cal.date(bySettingHour: 14, minute: 16, second: 0, of: now)!)!),
                ThoughtMessage(sender: .holistic, content: "Reminder set for Friday at 2pm. I'll also track your gut-brain axis synchrony over the next two days and flag any significant deviations. Your Instacart order for tomorrow includes probiotic-rich foods — I can suggest additions if you'd like.",
                    timestamp: cal.date(byAdding: .day, value: -2, to: cal.date(bySettingHour: 14, minute: 16, second: 3, of: now)!)!),
            ]),

            // 4 days ago — workout question
            ThoughtConversation(title: "4 Days Ago, 7:08 AM", messages: [
                ThoughtMessage(sender: .user, content: "Should I run today?",
                    timestamp: cal.date(byAdding: .day, value: -4, to: cal.date(bySettingHour: 7, minute: 8, second: 0, of: now)!)!),
                ThoughtMessage(sender: .holistic, content: "Your musculoskeletal recovery is at 91% — fully cleared. However, your sleep debt accumulated 0.8 hours last night. I'd recommend a moderate 30-minute run rather than high intensity. Your cardiovascular system can handle either, but recovery will be faster with the moderate approach.",
                    timestamp: cal.date(byAdding: .day, value: -4, to: cal.date(bySettingHour: 7, minute: 8, second: 4, of: now)!)!),
                ThoughtMessage(sender: .user, content: "Go with moderate",
                    timestamp: cal.date(byAdding: .day, value: -4, to: cal.date(bySettingHour: 7, minute: 9, second: 0, of: now)!)!),
                ThoughtMessage(sender: .holistic, content: "Syncing with Nike Run Club — moderate zone 2 run queued. I'll monitor your heart rate and cortisol in real-time. Current weather: 62°F, clear. Optimal conditions. Have a good run.",
                    timestamp: cal.date(byAdding: .day, value: -4, to: cal.date(bySettingHour: 7, minute: 9, second: 3, of: now)!)!),
            ]),
        ]
    }
}
